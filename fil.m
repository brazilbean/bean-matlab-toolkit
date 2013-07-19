%% Fil - filter
% Gordon Bean, November 2012
% Substitutes values according to the filter.

function data = fil( data, filt, value )
    if (nargin < 3)
        if islogical(data)
            value = false;
        else
            value = nan;
        end
    end
    if (nargin < 2)
        error('Not enough input arguments');
    end
    
    if (isa( filt, 'function_handle' ))
        filt = filt(data);
    end
    if (numel(value) == numel(data))
        data( filt ) = value(filt);
    else
        data( filt ) = value;
    end
end