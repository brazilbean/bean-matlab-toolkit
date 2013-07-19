% Gordon Bean, October 2010

function draw_box (x1, x2, y1, y2, color)
    if (nargin < 5)
        color = 'red';
    end
    
    line([x1 x1], ylim,'Color',color);
    line([x2 x2], ylim,'Color',color);
    line(xlim, [y1 y1],'Color',color);
    line(xlim, [y2 y2],'Color',color);

end