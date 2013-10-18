%% SCATTERNOTES - addes notes to points in a scatter plot
% Gordon Bean, November 2012
%
% notefun should be a function handle defined for @(xdata,ydata)

function notes = scatternotes( notefun, varargin )

    if ~isempty(varargin) && iscell(varargin{1})
        labels = varargin{1};
        varargin = varargin(2:end);
    else
        labels = {};
    end
    params = default_param( varargin, ...
        'labels', labels, ...
        'textArgs', {}, ...
        'axes', gca, ...
        'scatterfun', 1);
    labels = params.labels;
    
    %% Get xdata and ydata
    ch = get(params.axes, 'children');
    ty = get(ch, 'type');
    ch = ch( find(strcmp('hggroup', ty),1,'last') );
    if (isempty(ch))
        error('No scatter plot in current figure.');
    end
    
    xdata = get(ch, 'xdata');
    ydata = get(ch, 'ydata');
    
    %% Apply filters
    if isa(notefun, 'function_handle')
        notes = notefun(xdata, ydata);
    else
        notes = notefun;
    end

    %% Apply labels
    if ~isempty(labels)
        if (isnumeric(labels))
            labels = convert_labels(labels);
        end
        text( xdata(notes), ydata(notes), labels(notes), params.textargs{:} );
    end
    
    %% Apply color
    if isfield(params, 'scatterfun')
        if ~isa(params.scatterfun, 'function_handle')
            params.scatterfun = @(x,y,n) ...
                ...scatter( x(n), y(n), 20+10*n, n, 'filled');
                scatter( x(n), y(n), 30, [0.75 0 0], 'filled');
        end
        % i.e. scatterfun = ...
        %     @(x, y, notes) scatter(x(notes), y(notes), 50, 'r', 'filled')
        hold on;
        params.scatterfun(xdata, ydata, notes);
        hold off;
    end
    
    %% Wrap up
    if (nargout < 1)
        clear notes;
    end
    
    %% Sub-routines
    function clabels = convert_labels( labels )
        clabels = cell(size(labels));
        for ii = 1 : numel(labels)
            clabels{ii} = num2str(labels(ii));
        end
    end
end