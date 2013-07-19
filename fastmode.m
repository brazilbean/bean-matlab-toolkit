%% Fast mode - compute the mode using binning
% Gordon Bean, May 2013

function m = fastmode( data, bins )
    if (nargin < 2)
        bins = 50 : 10 : 200;
    end
    
    mxs = nan(size(bins));
    for ii = 1 : length(bins)
        [n,x] = hist(data(:), bins(ii));
        [~,mi] = max(n);
        mxs(ii) = x(mi);
    end
    m = mean(mxs);
    
end