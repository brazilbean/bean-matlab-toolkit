% A script for calculating the regression slope while ignoring nans
% Gordon Bean, October 2009, January 2011

% returns the least squares solution to y = mx + b

function [m] = slope(x,y,no_intercept)

    if (nargin < 3)
        no_intercept = 0;
    end

    if (numel(x) ~= numel(y))
        error('x and y must be the same length: %i vs %i', ...
            numel(x), numel(y));
    end

    % Turn x and y into column vectors.
    x = x(:);
    y = y(:);
    
    % Append 1's to find intercept, and remove nans.
    if (no_intercept)
        tmp = [x,y];
        tmp(isnan(tmp(:,1)),:) = [];
        tmp(isnan(tmp(:,2)),:) = [];
    
        m = tmp(:,1) \ tmp(:,2);
    else
        tmp = [ones(length(x),1),x,y];
        tmp(isnan(tmp(:,2)),:) = [];
        tmp(isnan(tmp(:,3)),:) = [];
    
        m = tmp(:,1:2) \ tmp(:,3);
    end
end % of slope