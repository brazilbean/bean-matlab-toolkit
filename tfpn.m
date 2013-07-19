% Gordon Bean, September 2010
% Returns the true pos, false pos, true neg, false neg

function [data cuts] = tfpn (truth, data, range)

    if (numel(range) == 1)
        range = linspace(min(data(:)),max(data(:)),range)';
    elseif (size(range,2) > size(range,1))
        range = range';
    end

    data = [ ...
        gtcount(data,range,truth) ...  True pos
        gtcount(data,range,~truth) ...  false pos
        ltcount(data,range,~truth) ... true negative
        ltcount(data,range,truth) ];   % false negative
    
    cuts = range;
end