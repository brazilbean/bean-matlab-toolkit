%% Add Error Bars
% Gordon Bean, January 2012
%
% For use with bar plots.

function add_error_bars( varargin )
    params = get_params( varargin{:} );
    
    if (~isfield( params, 'color' ))
        params.color = 'red';
    end
    
    if (~isfield( params, 'linewidth' ))
        params.linewidth = 4;
    end
    
    if (~isfield( params, 'linespecs' ))
        params.linespecs = {};
    end
    
    %% Get Plot Data
    ch = get(gca,'Children');
    chi = achar('hggroup',get(ch,'type'));
    ydata = get(ch(chi),'YData');
    xx = get(ch(chi), 'XData');
    
    if (~isfield( params, 'clearance' ))
        params.clearance = (max( ydata ) - min( ydata ))/2;
    end
    
    %% Get Lower and Upper Bounds
    if (isfield( params, 'error' ))
        lowers = ydata(:) - params.error(:);
        uppers = ydata(:) + params.error(:);
    else
        if (isfield( params, 'lower' ) && isfield( params, 'upper' ))
            lowers = params.lower;
            uppers = params.upper;
        else
            error('Provide either errors or lower and upper bounds');
        end
    end
    
    %% Plot Error Bars
    for ii = 1 : length(xx)
        line(xx(ii) * [1 1], [lowers(ii), uppers(ii)], ...
            'color', params.color, 'linewidth', params.linewidth, ...
            params.linespecs{:});
    end
    
end