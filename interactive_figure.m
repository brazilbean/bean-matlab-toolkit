%% Interactive figure
% Gordon Bean, June 2012
%
% Returns the selected points, [x y]

function points = interactive_figure( draw_fun, num_points, title_ )

    if (nargin < 3)
        title_ = sprintf('Pick %i points.', num_points);
    end
    
    states = struct;
    
    settings.figpos = [0 0 1000 800];
    
    settings.grid_spot_radius = 10;
    settings.grid_color = [0.9 0.3 0.3];
    settings.highlight_color = [1 0 0];
    
    %% Create Figure
    fig = figure('color','w', 'position', settings.figpos);
    movegui(fig,'center');

    %% Query user for points
    states.points = nan(num_points,2);
    states.cur_point = 1;

    draw;
    waitfor(fig);
    
    %% Functions
    function query_user_for_points( varargin )

        % Record selected point
        curpos = get(gca, 'currentPoint');
        states.points(states.cur_point,:) = curpos(1,[1 2]);
        states.cur_point = states.cur_point + 1;
        if (states.cur_point > num_points)
            points = states.points;
            close(fig);
            snapnow;
            return;
        end

        % Draw figure
        draw;

        % Draw the points
        rr = settings.grid_spot_radius;
        for c = 1 : states.cur_point - 1
            rectangle ...
                ('Position', [states.points(c,:)-rr rr*2 rr*2], ...
                'Curvature', [1 1],...
                'EdgeColor', settings.highlight_color );
        end
        
    end

    function draw
        clf(fig);
        figure(fig);
        im = draw_fun();
        set(im, 'buttonDownFcn', @query_user_for_points);
        title(title_,'fontsize',16);
    end
end