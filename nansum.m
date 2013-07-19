%% Nansum
% Gordon Bean, November 2012

function s = nansum( data, dim )

    data(isnan(data)) = 0;
    if (nargin < 2)
        s = sum(data);
    else
        s = sum(data,dim);
    end
end