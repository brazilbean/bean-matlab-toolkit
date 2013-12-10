%% NDTIMES - N-dimensional matrix multiplication
% Gordon Bean, November 2013

function ab = ndtimes(A, B, dims)

    if nargin < 3
        dims = [1 1];
    end
    
    % Permute A and B to multiply by dims
    asize = size(A);
    bsize = size(B);
    
    adims = setdiff(1:length(asize), dims(1));
    bdims = setdiff(1:length(bsize), dims(2));
    
    A_ = permute(A, [dims(1) adims]);
    B_ = permute(B, [dims(2) bdims]);
        
    % Multiply first dimensions
    A_ = reshape(A_, [asize(dims(1)) prod(asize(adims))]);
    B_ = reshape(B_, [bsize(dims(2)) prod(bsize(bdims))]);
    
    ab = A_' * B_;
    ab = reshape(ab, [asize(adims) bsize(bdims)]);

end