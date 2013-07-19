%% Add Significance Bars
% Gordon Bean, January 2012
% 
% For use with bar plots.

function add_significance_bars( g1, g2, varargin )
    params = get_params( varargin{:} );
    
    if (~isfield( params, 'marker' ))
        params.marker = '*';
    end
    
    if (~isfield( params, 'markersize' ))
        params.markersize = 16;
    end
        
    if (~isfield( params, 'clearfactor' ))
        params.clearfactor = 1.5;
    end
    
    %% Get Plot Data
    ch = get(gca,'Children');
    chi = achar('hggroup',get(ch,'type'));
    ydata = get(ch(chi),'YData');
    xdata = get(ch(chi),'XData');
    
    if (~isfield( params, 'clearance' ))
        params.clearance = (max( ydata ) - min( ydata ))/2;
    end
    
    %% Find key points
    g1m = mean(xdata(g1));
    g2m = mean(xdata(g2));
    
    g1y = max( ydata(g1) ) + params.clearance;
    g2y = max( ydata(g2) ) + params.clearance;
    
    if (~isfield( params, 'top' ))
        top = max( ydata ) + params.clearance * params.clearfactor;
    else
        top = params.top;
    end
    
    %% Plot Significance Bars
    line([g1m g1m g2m g2m], [g1y top top g2y] ,'color', 'k');
    
    %% Plot Group Bars
    g1min = xdata(min(g1));
    g1max = xdata(max(g1));
    
    g2min = xdata(min(g2));
    g2max = xdata(max(g2));
    
    line([g1min g1max], [g1y g1y], 'color','k');
    line([g2min g2max], [g2y g2y], 'color','k');
    
    %% Plot Stars
    text( mean([g1m g2m]), top, params.marker, 'color','k', ...
        'horizontalalignment','center', 'fontsize', params.markersize);
    
end