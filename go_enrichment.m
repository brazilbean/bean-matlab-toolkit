%% Go Enrichment - print GO enrichment
% Gordon Bean, October 2013

function enrich = go_enrichment( scores, names, go, filter, varargin )

    if nargin < 4 
        filter = @(x) x;
    end
    if ischar(filter)
        filter = @(x) x;
        varargin = [filter varargin];
    end
    
    params = default_param( varargin, ...
        'numiters', 1000, ...
        'fdr', 1/4, ...
        'verbose', true, ...
        'nbins', 30, ...
        'maxtermsize', 20);
    
    if isfield(params, 'effectFilter')
        filter = params.effectFilter;
    end
    
    %% Remove nans
    nix = isnan(scores);
    scores = scores(~nix);
    names = names(~nix);
    
    %% Define unique set of names, GO subset
    unames = unique(names(:));
    confoo = zeros(length(unames), numel(names));
    for a = 1 : numel(unames)
        confoo(a,:) = strcmp(unames{a}, names(:))';
    end
    
    confoofun = @(x) confoo * fil(x,@isnan,0) ./ sum(confoo,2);

    % Which genes
    gi = achar(unames, go.gene, 1);

    % Which terms
    molfun = strcmp('molecular_function', go.category);
    nogenes = sum(go.membermat(:,notnan(gi)),2) <= 1;
    toobig = sum(go.membermat(:,notnan(gi)),2) > params.maxtermsize;
    
    valterms = ~molfun & ~nogenes & ~toobig;

    mygo.membermat = zeros(sum(valterms), length(unames));
    mygo.membermat(:,~isnan(gi)) = go.membermat(valterms,notnan(gi));

    mygo.definition = go.definition(valterms);
    mygo.term = go.term(valterms);

    %% Score terms
    gene_scores = confoofun(scores(:));
    
    tn = sum(mygo.membermat,2);
    score_go = @(foo, mygo) bsxfun(@rdivide, mygo.membermat * foo, tn);
    term_scores = score_go(gene_scores, mygo);
    
    %% Score null model
    iters = params.numiters;
    perm_gene_scores = ...
        gene_scores(shake(repmat((1:length(gene_scores))', [1 iters])));
    tmp2 = score_go(perm_gene_scores, mygo);
    
    %% Compute FDR for each term score
    fdr = nan(size(term_scores));
    for n = 2 : params.maxtermsize
        null = in(tmp2(tn==n,:));
        hits = term_scores(tn==n);
        fdr(tn==n) = mean( bsxfun(@le, null, hits') ) ./ ...
            mean( bsxfun(@le, hits, hits') );
    end
    
    %% Display significant terms
    sigterms = fdr <= params.fdr;
    [~,ord] = sort(tn(sigterms)+fdr(sigterms));
    
    for ii = in(find(sigterms),ord)'
        % Print term
        fprintf('%s (%0.3f), FDR = %0.3f, n = %i\n', ...
            mygo.definition{ii}, term_scores(ii), fdr(ii), tn(ii));
        
        % Print genes, scores
        iii = mygo.membermat(ii,:) == 1;
        [tmps, ord2] = sort(gene_scores(iii));
        tmpn = in(unames(iii),ord2);
        n = length(tmpn);
        
        for kk = 1 : 5 : n
            kkk = kk : min(n, kk+4);
            fprintf('   ');
            iprintf(1, '%s (%0.2f), ', tmpn(kkk), tmps(kkk));
            fprintf('\n');
        end
        
        goi = achar(mygo.term(ii), go.term);
        missed = setdiff(go.gene(go.membermat(goi,:)==1), tmpn);
        if ~isempty(missed)
            fprintf('   Genes missing data: ');
            fprintf('%s ', missed{:});
            fprintf('\n');
        end
        fprintf('\n');
        
    end

    %% Return
    enrich.term_score = term_scores;
    enrich.tn = tn;
    enrich.fdr = fdr;
    enrich.params = params;
    enrich.unames = unames;
    enrich.convert = confoofun;
    enrich.score_go = score_go;
    enrich.mygo = mygo;
    enrich.filter = filter;
    
end