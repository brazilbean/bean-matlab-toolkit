%% X Percentile - calculate the percentile of x in the population
% Gordon Bean, June 2012

function p = xprctile( x, pop )

    pop = pop(~isnan(pop));
    p = reshape( sum( bsxfun(@gt, x(:)', pop) ), size(x)) ./ numel(pop);
    
end
