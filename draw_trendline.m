%% Draw_TrendLine
% Gordon Bean, October 2011
%
% Get's the XData and YData from the last plot, calculates the regression
% slope, and draws a trend line.

function draw_trendline (varargin)
    child = get(gca, 'children');
    xdata = get(child, 'xdata');
    ydata = get(child, 'ydata');
    
    if (iscell(xdata)), xdata = xdata{1}; end
    if (iscell(ydata)), ydata = ydata{1}; end
    
    m = slope( xdata, ydata );
    xx = xlim;
    
    if (nargin > 0)
        line(xx, xx*m(2) + m(1), varargin{:});
    else
        line(xx, xx*m(2) + m(1), 'linewidth', 2, ...
            'color', 'g', 'linestyle', '--');
    end
end