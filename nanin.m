%% NANIN - A NaN perpetuating index function
% Gordon Bean, August 2011

function out = nanin( data, index, type )
    
    if (any(isnan(index)))
        if (nargin < 3)
            type = 'nan';
        end
        
        switch type
            case {'nan','NaN'}
                out = nan(size(index));
            case 'zeros'
                out = zeros(size(index));
            case 'ones'
                out = ones(size(index));
            otherwise
                error('NANIN: type = ''nan'',''zeros'', or ''ones''');
        end
        out(~isnan(index)) = data(notnan(index));
    else
        out = in( data, index );
    end
end