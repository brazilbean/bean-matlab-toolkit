%% SCATTERNOTES - addes notes to points in a scatter plot
% Gordon Bean, November 2012
%
% notefun should be a function handle defined for @(xdata,ydata)

function notes = scatternotes( notefun, labels, varargin )

    if nargin < 2
        labels = {};
    end
    params = get_params(varargin{:});
    params = default_param( params, 'textArgs', {} );
    params = default_param( params, 'axes', gca );
    
    %% Get xdata and ydata
    ch = get(params.axes, 'children');
    ty = get(ch, 'type');
    ch = ch( achar('hggroup', ty) );
    if (isempty(ch))
        error('No scatter plot in current figure.');
    end
    
    xdata = get(ch, 'xdata');
    ydata = get(ch, 'ydata');
    
    %% Apply filters
    notes = notefun(xdata, ydata);

    %% Apply labels
    if ~isempty(labels)
        if (isnumeric(labels))
            labels = convert_labels(labels);
        end
        text( xdata(notes), ydata(notes), labels(notes), params.textargs{:} );
    end
    
    if (nargout < 1)
        clear notes;
    end
    
    function clabels = convert_labels( labels )
        clabels = cell(size(labels));
        for ii = 1 : numel(labels)
            clabels{ii} = num2str(labels(ii));
        end
    end
end