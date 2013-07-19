% NaN ignoring geometric mean
function [m] = gmean (data, varargin)
    
%     n = sum(~isnan(data),varargin{:});
%     data(isnan(data)) = 1;
%     m = prod(data,varargin{:}).^(1./n);
    m = exp(nanmean(log(data),varargin{:}));
    
end