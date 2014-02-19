%% h = HEXSCATTER( x, y, ... )
% Gordon Bean, February 2014
% A scatter-plot substitute - plot density of data in hexagonal patches
%
% Requires knnsearch from the Statistcs Toolbox when data are large.

function h = hexscatter( xdata, ydata, varargin )
    params = default_param( varargin, ...
        'xlim', [min(xdata(:)) max(xdata(:))], ...
        'ylim', [min(ydata(:)) max(ydata(:))], ...
        'res', 50, ...
        'drawEdges', false, ...
        'showZeros', false);
    
    if params.drawedges
        ec = 'flat';
    else
        ec = 'none';
    end
    
    %% Determine grid
    xl = params.xlim;
    yl = params.ylim;
    
    xbins = linspace(xl(1), xl(2), params.res);
    ybins = linspace(yl(1), yl(2), params.res);
    dy = diff(ybins([1 2]))*0.5;
    
    [X, Y] = meshgrid(xbins, ybins);
    n = size(X,1);
    Y(:,1:fix(end/2)*2) = ...
        Y(:,1:fix(end/2)*2) + repmat([0 dy],[n,fix(n/2)]);

    %% Map points to boxes
    nix = isnan(xdata) | isnan(ydata);
    xdata = xdata(~nix);
    ydata = ydata(~nix);
    
    % Which pair of columns?
    dx = diff(xbins([1 2]));
    foox = floor((xdata - xbins(1)) ./ dx)+1;
    foox(foox > length(xbins)) = length(xbins);
    
    % Which pair of rows?
    % Use the first row, which starts without an offset, as the standard
    fooy = floor((ydata - ybins(1)) ./ diff(ybins([1 2])))+1;
    fooy(fooy > length(ybins)) = length(ybins);
    
    % Which orientation
    orientation = mod(foox,2) == 1;

    % Map points to boxes
    foo = [xdata - xbins(foox)', ydata - ybins(fooy)'];

    % Which layer
    layer = foo(:,2) > dy;

    % Convert to block B format
    toflip = layer == orientation;
    foo(toflip,1) = dx - foo(toflip,1);

    foo(layer==1,2) = foo(layer==1,2) - dy;

    % Find closest corner
    dist = sqrt(sum(foo.^2,2));
    dist2 = sqrt(sum(bsxfun(@minus, [dx dy], foo).^2, 2));

    topright = dist > dist2;

    %% Map corners back to bins
    % Which x bin?
    x = foox + ~(orientation == (layer == topright));
    x(x > length(xbins)) = length(xbins);
    
    % Which y bin?
    y = fooy + (layer & topright);
    y(y > length(ybins)) = length(ybins);
    
    ii = sub2ind(size(X), y, x);

    %% Determine counts
    counts = sum(bsxfun(@eq, ii, 1:numel(X)),1);

    newplot;
    xscale = diff(xbins([1 2]))*2/3;
    yscale = diff(ybins([1 2]))*2/3;
    theta = 0 : 60 : 360;
    x = bsxfun(@plus, X(:), cosd(theta)*xscale)';
    y = bsxfun(@plus, Y(:), sind(theta)*yscale)';
    
    if params.showzeros
        h = patch(x, y, counts, 'edgeColor', ec);
    else
        jj = counts > 0;
        h = patch(x(:,jj), y(:,jj), counts(jj), 'edgeColor', ec);
    end
    
    if nargout == 0
        clear h;
    end
end