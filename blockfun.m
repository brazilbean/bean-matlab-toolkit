%% Blockfun - execute a function on a sliding block in a matrix
% Gordon Bean, May 2013
%
% FUN must be a function handle that operates on columns of a matrix.
% By default, edges of the image are padded with NaNs.

function out = blockfun( data, block, fun, varargin )
    params = default_param( varargin, ...
        'includeCenter', true, ...
        'padFunction', @nan, ...
        'positions', nan, ...
        'maxPosLength', 1e4);

    % Define neighbor indices
    if ~islogical(block)
        % Treat as dimensions of block
        block = true(block);
    end
    
    % Define positions to execute
    if isnan(params.positions)
        positions = 1:numel(data);
    else
        positions = params.positions;
    end
    
    % Define neighboring positions
    rni = (1 : size(block,1))' - fix(size(block,1)/2);
    rni = repmat(rni, [1 size(block,2)]);
    cni = (1 : size(block,2)) - fix(size(block,2)/2);
    cni = repmat(cni, [size(block,1) 1]);
    
    rni = rni(block);
    rni = rni(:);
    cni = cni(block);
    cni = cni(:);
    
    if ~params.includecenter
        rni = in(setdiff(rni, 0));
        cni = in(setdiff(cni, 0));
    end
    
    % Iterate to avoid Out of Memory errors.
    len_pos = params.maxposlength;
    num_mem_blocks = ceil(numel(positions) / len_pos);
    out = params.padfunction(size(data));
    
    for memblock = 1 : num_mem_blocks
        % Define positions
        pos = (1 : len_pos) + (memblock-1)*len_pos;
        pos = pos(pos <= length(positions));
        pos = positions(pos);
        
        % Get valid neighbors
        [r,c] = ind2sub(size(data), pos(:)');
        rr = bsxfun(@plus, r, rni);
        cc = bsxfun(@plus, c, cni);
        iival = rr > 0 & rr < size(data,1) & cc > 0 & cc < size(data,2);
        
        % Reshape to columns
        cols = params.padfunction(length(rni), length(pos));
        
        cols(iival) = data(sub2ind(size(data), rr(iival), cc(iival)));

        % Execute function and reshape output
        out(pos) = fun(cols);
        clear cols ii iival
    end
    
    % Return the requested positions
    if ~isnan(params.positions)
        out = out(params.positions);
    end
end