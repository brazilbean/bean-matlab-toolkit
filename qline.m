%% Quick Line
% Gordon Bean, March 2012

function h = qline( xx, yy, color, linewidth, varargin )
    if (nargin < 3)
        color = 'k';
    end
    if (nargin < 4)
        linewidth = 1;
    end
    if (mod(length(varargin),2)==1)
        lstyle = varargin{1};
        varargin = varargin(2:end);
    else
        lstyle = '-';
    end
    
    if isempty(yy)
        % Treat xx as the slope coefficients [1 x]
        m = xx;
        xx = xlim;
        yy = [ones(2,1) xx'] * m;
    end
    if (length(xx) < 2)
        xx = [xx xx];
    end
    if (length(yy) < 2)
        yy = [yy yy];
    end

    h = line (xx, yy, 'color', color, 'linewidth', linewidth, ...
        'linestyle', lstyle, varargin{:} );
    if nargout < 1
        clear h;
    end
end