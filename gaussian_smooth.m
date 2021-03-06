%% Gaussian Smooth
% Gordon Bean, December 2013
%
% Apply gaussian smoothing to the data

function ysmooth = gaussian_smooth(y, w, dim, varargin)
    % Default dim
    if nargin < 3
        dim = find(size(y)~=1,1);
        if isempty(dim)
            dim = 1;
        end
    end
    
    % Parse parameters
    params = default_param(varargin, ...
        'gaussianWidth', 3, ...
        'numEndAve', 10, ...
        'block', nan, ...
        'fillNans', false);
    
    % Reshape y
    yp = permute_dim(y, dim);
    sz = size(yp);
    yp = reshape(yp, [sz(1) prod(sz(2:end))]);
    
    % Fix nans, if specified
    if params.fillnans
        nn = 1:size(yp,1);
        for ii = 1 : size(yp,2)
            nans = isnan(yp(:,ii));
            if mean(nans) < 0.5 % must be at least 50% non-nan.
                yp(nans,ii) = interp1(nn(~nans), yp(~nans,ii), nn(nans), ...
                    'linear','extrap');
            else
                % Do nothing - let nans affect smoothed data.
            end
        end
    end
    
    n = size(yp,1);
    ysmooth = yp;

    % Set up data for processing
    np = params.numendave;
    y_ = [repmat(mean(yp(1:np,:),1),[w,1]); 
          yp; 
          repmat(mean(yp(end-np+1:end,:),1),[w,1])];

    % Define the guassian window
    gw = params.gaussianwidth;
    if isnan(params.block)
        normpdf = @(xx) exp(-xx.^2 ./ 2) ./ sqrt(2*pi);
        block = normpdf(linspace(-gw, gw, 2*w+1));
        block = block ./ sum(block);
    else
        block = params.block;
    end
    
    % Smooth the data
    for ii = 1 : n
%         ysmooth(ii,:,:) = ndtimes(block, y_(ii:ii+2*w,:,:), [2, 1]);
        ysmooth(ii,:,:) = ...
            ndtimes(block, y_(ii:ii+length(block)-1,:,:), [2, 1]);
    end
    ysmooth = reshape(ysmooth, sz);
    ysmooth = ipermute_dim(ysmooth, size(y), dim);
    
end