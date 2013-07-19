%% Draw Square Line
% Gordon Bean, January 2011
%
% Draws the 1-to-1 line on a plot.
% All arguments are passed to the call to 'line'.

function draw_square_line (varargin)
    a = min([xlim,ylim]);
    b = max([xlim,ylim]);

    if (isempty(varargin))
        line([a b],[a b], 'color','k');
    else
        line([a b],[a b], varargin{:} );
    end
    
end