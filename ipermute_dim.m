%% IPERMUTE_DIM - inverse permute dim
% Gordon Bean, July 2013

function out = ipermute_dim( data, sz, dim )

    dims = 1 : length(sz);
    dims = circshift(dims, [0 1-dim]);
    out = ipermute(data, dims);

end