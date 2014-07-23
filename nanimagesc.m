%% NanImagesc - heatmap function representing NaN values
% Gordon Bean, July 2014

function h = nanimagesc(data, varargin)
    params = default_param( varargin, ...
        'nancolor', get(gcf, 'color')); % Can be 'transparent'
    [nr, nc] = size(data);
    nans = isnan(data);
    
    % Vertices
    [cols, rows] = meshgrid(1:nc, 1:nr);
    xverts = bsxfun(@plus, 0.5*[-1 -1 1 1]', cols(:)');
    yverts = bsxfun(@plus, 0.5*[-1 1 1 -1]', rows(:)');
    
    newplot;
    
    % Plot data
    h = patch(xverts(:,~nans), yverts(:,~nans), data(~nans)', ...
        'edgeColor', 'none');
    
    % Plot nans
    if ~strcmpi(params.nancolor, 'transparent')
        patch(xverts(:,nans), yverts(:,nans), params.nancolor, ...
            'edgeColor', 'none');
    else
        % Do nothing
    end
    set(gca, 'ydir', 'reverse');
    
    xlim([min(xverts(:)) max(xverts(:))]);
    ylim([min(yverts(:)) max(yverts(:))]);
    
    if nargin == 0
        clear h;
    end
end