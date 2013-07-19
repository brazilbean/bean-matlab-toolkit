%% Blockfun - execute a function on a sliding block in a matrix
% Gordon Bean, May 2013
%
% FUN must be a function handle that operates on columns of a matrix.
% By default, edges of the image are padded with NaNs.

function out = blockfun( data, block, fun, varargin )
    params = default_param( varargin, ...
        'includeCenter', true, ...
        'padFunction', @nan, ...
        'positions', 1 : numel(data), ...
        'maxPosLength', 1e4);

    % Define neighbor indices
    if ~islogical(block)
        % Treat as dimensions of block
        block = true(block);
    end
    
    dh = size(data,1);
    hi = (1 : size(block,1))' - fix(size(block,1)/2);
    wi = (1 : size(block,2)) - fix(size(block,2)/2);
    ni = bsxfun(@plus, hi', dh*wi');
    
    ni = ni(block);
        
    if ~params.includecenter
        ni = in(setdiff(ni, 0))';
    end
    
    % Iterate to avoid Out of Memory errors.
    len_pos = params.maxposlength;
    num_mem_blocks = ceil(numel(params.positions) / len_pos);
    out = params.padfunction(size(data));
    
    for memblock = 1 : num_mem_blocks
        % Define positions
        pos = (1 : len_pos) + (memblock-1)*len_pos;
        pos = pos(pos <= length(params.positions));
        pos = params.positions(pos);
        
        % Reshape to columns
        cols = params.padfunction(length(ni), length(pos));
        ii = bsxfun(@plus, pos, ni);
        iival = ii > 0 & ii <= numel(data);

        cols(iival) = data(ii(iival));

        % Execute function and reshape output
        out(pos) = fun(cols);
        clear cols ii iival
    end
end