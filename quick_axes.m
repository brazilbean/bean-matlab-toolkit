%% Quick Axes
% Gordon Bean, January 2012

function a = quick_axes( pos, units )
    if (nargin < 2)
        units = 'centimeters';
    end
    
    a = axes('units', units, ...
    'outerposition', pos, ...
    'units','normalized','color','none');

    if (nargout < 1)
        clear a;
    end
end