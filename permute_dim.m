%% Permute dim - put the specified dimension first
% Gordon Bean, July 2013

function out = permute_dim( data, dim )

    dims = 1 : length(size(data));
    dims = circshift(dims, [0 1-dim]);
    out = permute( data, dims );

end