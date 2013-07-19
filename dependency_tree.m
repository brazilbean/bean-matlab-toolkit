%% Dependency Tree
% Gordon Bean, October 2012
% 
% Params
% prefix <'/cellar/users/gbean/'>
% - restrict dependencies to this path prefix
% outfile
% - the file to store the output

function [ deps params ] = dependency_tree( fun, varargin )
    params = get_params( varargin{:} );
    params = default_param( params, 'prefix', '/cellar/users/gbean/' );
    params = default_param( params, 'noRecursion', {} ); % internal use

    %% Get dependencies
    deps = depfun( fun, '-toponly', '-quiet' );

    %% Remove MATLAB functions
    subfun = @(x) x(1:min(length(x),length(params.prefix)));
    keep = strcmp( cellfun(subfun, deps, 'uniformOutput', false), ...
        params.prefix );
    deps = deps( keep );
    
    %% Print
    original_call = false;
    if (isfield( params, 'outfile' ) && ~isfield( params, 'fid' ))
        params.fid = fopen( params.outfile, 'wt' );
        original_call = true;
    elseif (~isfield(params, 'outfile') && ~isfield( params, 'fid' ))
        params.fid = 1;
        original_call = true;
    end
    
    if (numel(deps) > 1 && isfield( params, 'fid' ))
        names = get_function_names( deps );
        iprintf(params.fid, '%s\t%s\n', ...
            repmat(names(1), [length(names)-1 1]), names(2:end) );
    end
    
    %% Recurse
    params.norecursion = union( params.norecursion, deps(1) );
    for dep = in(setdiff( deps, params.norecursion ))'
        [d2 p2] = dependency_tree ...
            (dep{1},'noRecursion', params.norecursion, 'fid', params.fid );
        deps = union( deps, d2 );
        params.norecursion = p2.norecursion;
        params.norecursion = union( params.norecursion, dep );
    end

    %% Close
    if (original_call && params.fid > 2)
        fclose( params.fid );
    end
    
    %% Dependency file
    if isfield(params, 'depfile')
        fid = fopen(params.depfile, 'wt');
        paths = cellfun(@(x) x(1:find(x=='/',1,'last')), ...
            deps, 'uniformOutput', 0);
        names = cellfun(@(x) x(find(x=='/',1,'last')+1:end), ...
            deps, 'uniformOutput', 0); 
        fprintf(fid, 'method\tpath\n');
        iprintf(fid, '%s\t%s\n', names, paths);
        fclose(fid);
    end
    function names = get_function_names( funs )
        names = cell(size(funs));
        for ii = 1 : length(funs)
            tmp = textscan( funs{ii}, '%s ', 'delimiter', '/' );
            names(ii) = tmp{1}(end);
        end
    end
end