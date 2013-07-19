%% Weighted Mean
% Gordon Bean, October 2010
% Revised, June 2011
%
% WMEAN( data, weights, dim )

function [wm ws] = wmean( data, w, dim)
    if (nargin < 3)
        dim = 1;
    end
    
    nix = isnan(data) | isnan(w);
    data(nix) = nan;
    w(nix) = nan;
    
    ws = nansum( w, dim );
    ws(sum(~isnan(w), dim)==0) = nan;
    
    wm = nansum( data .* w, dim ) ./ ws;
    wm(sum(~isnan(data), dim)==0) = nan;

end % of wmean