%% mcbar - Multi-color bar chart
% Gordon Bean, March 2013

function h = mcbar( data, colors, varargin )
    params = get_params( varargin{:} );
    params = default_param(params, 'width', 0.8);
    wid = params.width;
    
    n = length(data);
    
    %% Handle colors
    if (nargin < 2)
        colors = get(gca, 'colororder');
    end
    if (ischar(colors))
        % Treat as color codes
        tmp = cell(numel(colors),1);
        for ii = 1 : length(tmp), tmp{ii} = colors(ii); end
    else
        % Treat as RGB
        if (size(colors,2) ~= 3)
            error('RGB values should be n x 3');
        end
        tmp = cell(size(colors,1),1);
        for ii = 1 : length(tmp), tmp{ii} = colors(ii,:); end
    end
    colors = tmp;
    if (length(colors) < n)
        colors = repmat(colors, [ceil(n/length(colors)), 1]);
    end
    
    %% Plot
    xpos = 1 : n;
    newplot;
    h = nan(n,1);
    for ii = 1 : n
        % Patch
        vx = xpos(ii) + [-wid/2 -wid/2 wid/2 wid/2];
        vy = [0 data(ii) data(ii) 0];
        h(ii) = patch(vx, vy, colors{ii});
    end
    set(gca, 'xtick', 1 : n );
    
    if (isfield(params, 'labels'))
        set(gca, 'xticklabel', params.labels);
    end
    if (nargout < 1)
        clear h;
    end
end