%% nanprod - nan-ignoring product
% Gordon Bean, 2011

function [p] = nanprod(data,varargin)
    data(isnan(data)) = 1;
    p = prod(data,varargin{:});
end