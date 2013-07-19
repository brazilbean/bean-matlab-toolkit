% This function returns the rank p-values of the provided list
% The p-value of a[i] = rank(a[i]) / N
% NOTE: data should be in columns
% Gordon Bean, August 2010

function [pvals ranks] = prank (data)

    N = length(data);
    
    [~, order] = sort(data);
    [~, ranks] = sort(order);
    
    ranks(isnan(data)) = nan;
    pvals = ranks ./ N;
    
end % of prank