%% Dependency Tree
% Gordon Bean, October 2012
% 
% Params
% prefix <'/cellar/users/gbean/'>
% - restrict dependencies to this path prefix
% outfile
% - the file to store the output

function [ dependencies, visited, params ] = dependency_tree ...
    ( start, varargin )
    params = default_param( varargin, ...
        'ignore', {'.'}, ... currently only ignores top-level directories
        'ignorebuiltins', true, ...
        'outputfile', []);
    
    %% Crawl directories
    if isdir(start)
        if start(1) ~= '/'
            error('Starting path must be absolute: %s', start);
        end
        if start(end) ~= '/'
            start = [start '/'];
        end
        queue = crawl_directories(start, params.ignore);
    else
        if ~iscell(start)
            start = {start};
        end
        queue = start;
    end
    queue = unique(queue);
    
    %% Crawl dependencies
    depsize = 100;
    dependencies = cell(depsize,2);
    deppos = 1;
    
    % Crawl
    visited = {};
    qpos = 1;
    while qpos <= length(queue)
        % Get next item
        name = queue{qpos};
        visited = union(visited, {name});
        
        % Get dependencies
        deps = depfun(name, '-toponly', '-quiet');
        % depfun returns the full path

        % Remove MATLAB built-ins
        if params.ignorebuiltins
            deps = filter_builtins(deps, 'matlab/');
        end

        % Get dependency names
        depnames = get_function_names(deps);
        names = get_function_names({name});
        depnames = setdiff(depnames, names); % remove self edges
        
        % Grow dependency list, if necessary
        if deppos + length(depnames) > size(dependencies,1)
            tmpdeps = dependencies;
            dependencies = cell(size(dependencies,1)*2,2);
            dependencies(1:size(tmpdeps,1),:) = tmpdeps;
        end
        
        % Save dependencies
        if ~isempty(depnames)
            dependencies(deppos:deppos+length(depnames)-1,:) = ...
                [repmat(names, size(depnames)), depnames];
            deppos = deppos + length(depnames);
        end
%         iprintf(fid,'%s\t%s\n', repmat(names, size(depnames)), depnames);

        % Remove MATLAB toolkit functions
        deps = filter_builtins(deps, '');
        
        % Add dependencies to queue
        deps = filter_visited(deps, visited);
        deps = filter_visited(deps, queue);
        queue = [queue; deps];
        
        % Increment loop
        qpos = qpos + 1;
    end
    keep = 1 : find(cellfun(@isempty, dependencies(:,1)),1)-1;
    dependencies = dependencies(keep,:);
    
    %% Print nodes and edges 
    if ~isempty(params.outputfile)
        fid = fopen(params.outputfile,'wt');
        fprintf(fid,'<graphml>\n');
        
        % Print attribute keys
        % Node path
        fprintf(fid,['\t<key id="nodepath" for="node" ' ...
            'attr.name="path" attr.type="string">\n']);
        fprintf(fid,'\t\t<default></default>\n');
        fprintf(fid,'\t</key>\n');
        
        % Open graph
        fprintf(fid,'\t<graph edgedefault="directed">\n');
        
        % Print nodes
        names = get_function_names(visited);
        paths = get_function_paths(visited);
        formatstr = ['\t\t<node id="%s">\n\t\t\t<data key="nodepath">%s'...
            '</data>\n\t\t</node>\n'];
        iprintf(fid, formatstr, names', paths');
        
        % Print edges
        formatstr = '\t\t<edge source="%s" target="%s"/>\n';
        iprintf(fid, formatstr, dependencies);
        
        fprintf(fid, '\t</graph>\n</graphml>\n');
        fclose(fid);
    end
    
    %% Wrap up
    if (nargout < 1)
        clear dependencies visited;
    end
    
    %% Functions
    function files = crawl_directories(startdir, ignore)
        % Look in directory
        dirs = dir(startdir);
        
        % Save files
        files = dirs(arrayfun(@(x) ~x.isdir && x.name(1) ~= '.', dirs));
        files = {files.name}';
        files = cellfun(@(x) [startdir x], files, 'uniformOutput', 0);
        
        % Recurse on dirs (ignore those in params.ignore)
        dirs = dirs(arrayfun(@(x) x.isdir && x.name(1) ~= '.', dirs));
        dirs = filter_ignore(dirs, ignore);
        for d = dirs(:)'
            files = [files; 
                     crawl_directories([startdir d.name '/'], ignore)];
        end
    end

    function out = filter_ignore(dirs, ignore)
        % Ignore a directory if one of the prefixes in 'ignore' matches the
        % beginning of the directory path
        prefix_match = @(x, ig) length(ig) <= length(x) && ...
            all(x(1:length(ig)) == ig);
        in_ignore = @(x, ignore) ...
            any(cellfun(@(ig) prefix_match(x,ig) ,ignore));
        out = dirs( ~arrayfun(@(x) in_ignore(x.name, ignore), dirs) );
    end

    function out = filter_visited(dirs, visited)
        nix = cellfun(@(x) ismember(x, visited), dirs);
        out = dirs(~nix);
    end

    function deps = filter_builtins(deps, toolbox)
        % Determine built-in prefix
        foo = which('depfun');
        first_pos = find(foo == '/', 1);
        matlab_pos = in(strfind(foo, 'matlab'),1);
        pos = in(strfind(foo(matlab_pos:end), '/'),1);
        prefix = foo(first_pos : matlab_pos+pos-1);
        prefix = [prefix 'toolbox/' toolbox];
        
        % Filter functions
        subfun = @(x) x(1:min(length(x),length(prefix)));
        nix = strcmp( cellfun(subfun, deps, 'uniformOutput', false), ...
            prefix );
        deps = deps( ~nix );
    end

    function names = get_function_names( funs )
        names = cell(size(funs));
        for ii = 1 : length(funs)
            tmp = textscan( funs{ii}, '%s', 'delimiter', '/' );
            names(ii) = tmp{1}(end);
        end
    end

    function paths = get_function_paths( funs )
        pathfun = @(file) file(1:find(file=='/',1,'last'));
        paths = cellfun(pathfun, funs, 'uniformOutput', false);
    end

end

%     params = get_params( varargin{:} );
%     params = default_param( params, 'prefix', '/cellar/users/gbean/' );
%     params = default_param( params, 'noRecursion', {} ); % internal use
% 
%     %% Get dependencies
%     deps = depfun( fun, '-toponly', '-quiet' );
% 
%     %% Remove MATLAB functions
%     subfun = @(x) x(1:min(length(x),length(params.prefix)));
%     keep = strcmp( cellfun(subfun, deps, 'uniformOutput', false), ...
%         params.prefix );
%     deps = deps( keep );
%     
%     %% Print
%     original_call = false;
%     if (isfield( params, 'outfile' ) && ~isfield( params, 'fid' ))
%         params.fid = fopen( params.outfile, 'wt' );
%         original_call = true;
%     elseif (~isfield(params, 'outfile') && ~isfield( params, 'fid' ))
%         params.fid = 1;
%         original_call = true;
%     end
%     
%     if (numel(deps) > 1 && isfield( params, 'fid' ))
%         names = get_function_names( deps );
%         iprintf(params.fid, '%s\t%s\n', ...
%             repmat(names(1), [length(names)-1 1]), names(2:end) );
%     end
%     
%     %% Recurse
%     params.norecursion = union( params.norecursion, deps(1) );
%     for dep = in(setdiff( deps, params.norecursion ))'
%         [d2 p2] = dependency_tree ...
%             (dep{1},'noRecursion', params.norecursion, 'fid', params.fid );
%         deps = union( deps, d2 );
%         params.norecursion = p2.norecursion;
%         params.norecursion = union( params.norecursion, dep );
%     end
% 
%     %% Close
%     if (original_call && params.fid > 2)
%         fclose( params.fid );
%     end
%     
%     %% Dependency file
%     if isfield(params, 'depfile')
%         fid = fopen(params.depfile, 'wt');
%         paths = cellfun(@(x) x(1:find(x=='/',1,'last')), ...
%             deps, 'uniformOutput', 0);
%         names = cellfun(@(x) x(find(x=='/',1,'last')+1:end), ...
%             deps, 'uniformOutput', 0); 
%         fprintf(fid, 'method\tpath\n');
%         iprintf(fid, '%s\t%s\n', names, paths);
%         fclose(fid);
%     end
%     
%     function names = get_function_names( funs )
%         names = cell(size(funs));
%         for ii = 1 : length(funs)
%             tmp = textscan( funs{ii}, '%s ', 'delimiter', '/' );
%             names(ii) = tmp{1}(end);
%         end
%     end
% end
% 
