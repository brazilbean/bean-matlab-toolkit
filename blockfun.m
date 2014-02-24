%% Blockfun - execute a function on a sliding block over a matrix
% Gordon Bean, May 2013
%
% Syntax
% OUT = blockfun( DATA, BLOCK, FUN )
% OUT = blockfun( DATA, BLOCK, FUN, 'Name', Value, ... )
% 
% Description
% OUT = blockfun( DATA, BLOCK, FUN ) returns a matrix OUT of dimensions
% size(DATA), where each element corresponds to the value obtained by
% exectuing FUN on the values within a 2D window defined by BLOCK centered
% at each element in DATA. 
% 
% BLOCK can be a user defined binary matrix, used as a mask centered at
% each position to identify the elements passed to FUN. Or BLOCK can be a
% 1- or 2-element vector indicating the dimensions of the 2D window.
% 
% FUN is a function handle.
% 
% OUT = blockfun( DATA, BLOCK, FUN, 'Name', Value, ... ) accepts additional
% name-value pairs from the following list (defaults in {}):
%  'includeCenter' { true } - if false, the center value of the 2D window
%  is excluded from the input to FUN.
%  'padFunction' { @nan } - a function handle used to pad the matrix DATA
%  when the 2D window extends beyond the bounds of the matrix.
%  'positions' { 1 : numel(data) } - a vector containing the linear indices
%  at which to execute FUN. When specified, OUT is of the same size as the
%  position vector. 
%  'maxPosLength' { 1e4 } - a scalar indicating the maximum number of
%  positions to evaluate at a time. If this value is too large, MATLAB may
%  experience out of memory errors. 
% 
% Examples
% Determine the underlying shape of a surface with noise
% [xx, yy] = meshgrid((1:100) - 51);
% 
% subplot(1,3,1);
% surface = 2*xx + 0.4*yy + 0.2*xx.*yy;
% imagesc(surface); axis square; axis off;
% 
% subplot(1,3,2);
% noisy = surface + randn(size(surface))*100;
% imagesc(noisy); axis square; axis off;
% 
% subplot(1,3,3);
% recovered = blockfun( noisy, [6 6], @nanmedian );
% imagesc(recovered); axis square; axis off;

function out = blockfun( data, block, fun, varargin )
    params = default_param( varargin, ...
        'includeCenter', true, ...
        'padFunction', @nan, ...
        'positions', nan, ... See below for default value
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
    rni = (1 : size(block,1))' - ceil(size(block,1)/2);
    rni = repmat(rni, [1 size(block,2)]);
    cni = (1 : size(block,2)) - ceil(size(block,2)/2);
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
        iival = rr > 0 & rr <= size(data,1) & cc > 0 & cc <= size(data,2);
        
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
    
        %% Function: default_param
    % Gordon Bean, March 2012
    % Copied from https://github.com/brazilbean/bean-matlab-toolkit
    function params = default_param( params, varargin )
        if (iscell(params))
            params = get_params(params{:});
        end
        defaults = get_params(varargin{:});

        for f = fieldnames(defaults)'
            field = f{:};
            if (~isfield( params, lower(field) ))
                params.(lower(field)) = defaults.(field);
            end
        end
    end

    %% Function: get_params - return a struct of key-value pairs
    % Gordon Bean, January 2012
    %
    % Usage
    % params = get_params( ... )
    %
    % Used to parse key-value pairs in varargin - returns a struct.
    % Converts all keys to lower case.
    %
    % Copied from https://github.com/brazilbean/bean-matlab-toolkit
    function params = get_params( varargin )
        params = struct;

        nn = length(varargin);
        if (mod(nn,2) ~= 0)
            error('Uneven number of parameters and values in list.');
        end

        tmp = reshape(varargin, [2 nn/2]);
        for kk = 1 : size(tmp,2)
            params.(lower(tmp{1,kk})) = tmp{2,kk};
        end
    end
end