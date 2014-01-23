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
        'maxtermsize', 50);
    
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

    gi = achar(unames, go.gene, 1);
    mygo = zeros(size(go.membermat,1), length(unames));
    mygo(:,~isnan(gi)) = go.membermat(:,notnan(gi));

    molfun = strcmp('molecular_function', go.category);

    %% Score terms
    foo2 = confoofun(scores(:));
    
    tn = sum(mygo,2);
    score_go = @(foo, mygo) apply(sum(mygo,2), @(tn) ...
        fil( bsxfun(@times, ...
        bsxfun(@rdivide, mygo * foo, tn), ~molfun), @(x)x==0));

    tmp = score_go(foo2, mygo);
    
    %% Score null model
    iters = params.numiters;
    foorand = foo2(shake(repmat((1:length(foo2))', [1 iters])));
    tmp2 = score_go(foorand, mygo);
    
    %% Compare ratios
    m = prctile(tmp2(:), [0.1 99.9]);
    bins = [-inf linspace(m(1), m(2), params.nbins) inf];
    
    mts = params.maxtermsize;
    counts = nan(length(bins),mts);
    rcounts = nan(length(bins),mts);
    for t = 1 : mts
        counts(:,t) = mean(histc( tmp2(tn==t,:), bins ),2);
        rcounts(:,t) = histc( tmp(tn==t,:), bins );
    end
    
    % Terms greater than mts are ignored.
    
    %% Pick enriched terms
    [bi, ti] = find(bsxfun(@and, ...
        counts ./ rcounts < params.fdr, filter(bins')));

    %% Display terms
    binselect = @(x, bin, val) ...
    apply(in((1:length(x))', x(:)>=bin(1) & x(:)<bin(2) & val(:)), @(y) ...
    [y x(y)]); 
    
    enrich.displayed = {};
    if params.verbose
        fprintf('\n\n\n');
        for ii = 1:length(bi);
            bin = bins(bi(ii)+[0 1]);

            tmpi = binselect(tmp, bin, tn == ti(ii));
            def = go.definition(tmpi(:,1));
            enrich.displayed = union(enrich.displayed, def);

            fprintf('Group %i - FDR = %0.3f, term size = %i\n',...
                ii, counts(bi(ii),ti(ii))./rcounts(bi(ii),ti(ii)), ti(ii));
            fprintf('----------------------------------------\n');
            for jj = 1 : length(def)
                jjj = mygo(tmpi(jj,1),:)==1;

                tmpratio = ...
                    sum(apply(foo2(jjj),@(x) x >= bin(1) & x < bin(2)));
                fprintf(' %i) %s (%0.3f)\n', jj, def{jj}, tmp(tmpi(jj,1)));
                
                [tmpn, tmpf] = deal(unames(jjj), foo2(jjj));
                [tmpf, ord] = sort(tmpf);
                tmpn = tmpn(ord);

                n = length(tmpn);
                for kk = 1 : 5 : n
                    kkk = kk : min(n, kk+4);
                    fprintf('   ');
                    iprintf(1,'%s (%0.2f), ', tmpn(kkk), tmpf(kkk));
                    fprintf('\n')
                end
            end
            fprintf('\n');
        end
        fprintf('\n');
    end
    
    %% Return
    enrich.term_score = tmp;
    enrich.tn = tn;
    enrich.fdr = counts ./ rcounts;
    enrich.bins = bins;
    enrich.params = params;
    enrich.unames = unames;
    enrich.convert = confoofun;
    enrich.score_go = score_go;
    enrich.randcounts = counts;
    enrich.counts = rcounts;
    enrich.mygo = mygo;
    enrich.filter = filter;
    
end