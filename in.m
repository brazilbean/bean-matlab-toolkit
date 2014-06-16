%% in (array, index) - vectorize or index into an array or matrix
% Gordon Bean, May 2010
%
% This function has 3 uses:
% 1) Vectorize the input - When only one input is provided, the input is
% vectorized. 
%
% Example
% >> foo = rand(2,2)
% 
% foo =
% 
%       0.96489      0.97059
%       0.15761      0.95717
% 
% >> in(foo)
% 
% ans =
% 
%       0.96489
%       0.15761
%       0.97059
%       0.95717
%
% 2) Index into an array - When the second argument is an array of indexes,
% the values in 'array' corresponding to these indexes are returned.
% Note: when 'array' is a matrix and 'index' is an array, IN treats 'array'
% as an array instead of a matrix.
%
% Example
% >> foo = rand(5,1)
% 
% foo =
% 
%       0.84913
%       0.93399
%       0.67874
%       0.75774
%       0.74313
% 
% >> in(foo, [1 4 5])
% 
% ans =
% 
%       0.84913
%       0.75774
%       0.74313
%
% 3) Index into a matrix - When 'array' is a matrix of size [m n ...] and:
%  1)'index' is a 2D logical matrix of size [m n], in( array, index ) 
%   returns a maxtrix of size [sum(index(:)) ...], effectively performing a
%   2D indexing.
%  2) 'index' is a 2D non-logical matrix, in( array, index ) returns a
%   matrix of size [numel(index)/2 ...] where each row corresponds to the
%   coordinate pairs indicated in 'index'.
%
% Example
%>> foo = rand(3,3,3)
% 
% foo(:,:,1) =
% 
%         0.119      0.34039      0.75127
%       0.49836      0.58527       0.2551
%       0.95974      0.22381      0.50596
% 
% 
% foo(:,:,2) =
% 
%       0.69908      0.54722      0.25751
%        0.8909      0.13862      0.84072
%       0.95929      0.14929      0.25428
% 
% 
% foo(:,:,3) =
% 
%       0.81428      0.34998      0.61604
%       0.24352       0.1966      0.47329
%       0.92926      0.25108      0.35166
% 
% >> in(foo, foo(:,:,1)<0.5)
% 
% ans =
% 
%         0.119      0.69908      0.81428
%       0.49836       0.8909      0.24352
%       0.34039      0.54722      0.34998
%       0.22381      0.14929      0.25108
%        0.2551      0.84072      0.47329
% 
% >> in(foo, [1 1 2 3; 1 2 3 3]')
% 
% ans =
% 
%         0.119      0.69908      0.81428
%       0.34039      0.54722      0.34998
%        0.2551      0.84072      0.47329
%       0.50596      0.25428      0.35166
%

function [out] = in (array, index)
    
    if (nargin < 2)
        % Squash array, no index provided
        out = array(:);
        
    elseif (isa( index, 'function_handle') )
        out = array( index(array) );
        
    elseif (~islogical(index) && length(index) == numel(index))
        % Index is a vector or scalar of indexes
        out = array(index);
        
    elseif (islogical(index) && size(index,1) == size(array,1) && ...
            size(index,2) == size(array,2))
        % Use logical index in first two dimensions
        dim = size(array);
        
        if ( dim(1)*dim(2) ~= numel(index) )
            warning('BEAN_EMAP_TOOLKIT:in',...
                'Size of logical index does not match array');
        end
        
        array2 = reshape(array, [dim(1)*dim(2) dim(3:end) 1]);
        out = reshape( array2(index(:),:), [sum(index(:)) dim(3:end) 1]);
        
    elseif islogical(index) && numel(index) == numel(array)
        out = array(index);
        
    else
        % Index into first 2 dimensions using coordinates
        dim = size(array);
        
        index = sub2ind(dim, index(:,1), index(:,2));
        array2 = reshape(array, [dim(1)*dim(2) dim(3:end)]);
        out = reshape(array2(index,:), [numel(index) dim(3:end)]);

    end

end % of in
