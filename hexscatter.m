%% h = HEXSCATTER( x, y, ... )
% Gordon Bean, February 2014
% A scatter-plot substitute - plot density of data in hexagonal patches

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
    ybins = linspace(yl(1), yl(2)+0.5, params.res);

    [X, Y] = meshgrid(xbins, ybins);
    n = size(X,1);
    dy = diff(X(1,[1 2]))/2;
    Y(:,1:fix(end/2)*2) = ...
        Y(:,1:fix(end/2)*2) + repmat([0 dy],[n,fix(n/2)]);

    %% Assign points to bins
    nix = isnan(xdata) | isnan(ydata);
    xdata = xdata(~nix);
    ydata = ydata(~nix);
    
    if numel(xdata) < 1e4
        dists = sum(bsxfun(@minus, [xdata ydata], ...
            permute([X(:) Y(:)], [3 2 1])).^2,2);
        ii = argmin(dists, 3);
    else
        % memory-efficient version
        ii = nan(size(xdata));
        for jj = 1 : numel(ii)
            ii(jj) = argmin( (xdata(jj)-X(:)).^2 + (ydata(jj)-Y(:)).^2 );
        end
    end
    
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