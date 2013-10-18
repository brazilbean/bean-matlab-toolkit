%% SurfaceFit - fit a polynomial surface to the data
% Gordon Bean, October 2013

function [fitted, beta, mu] = surfacefit( data, varargin )
    params = default_param(varargin, 'degree', 7);
    dims = size(data);
    data = data(:);
    
    %% Define Domain
    [xx yy] = meshgrid(1:dims(2), 1:dims(1));
    mu.x = [mean(xx(:)) std(xx(:))];
    mu.y = [mean(yy(:)) std(yy(:))];

    xx = (xx-mu.x(1))./mu.x(2);
    yy = (yy-mu.y(1))./mu.y(2);

    %% Define exponents
    np = params.degree;
    powers = np : - 1 : 0;

    %% Domain ^ exponent
    xxp = bsxfun(@power, xx(:), powers);
    yyp = bsxfun(@power, yy(:), powers);

    %% Crossproduct of polynomials
    % yp by xp in the 2nd dimension
    xyp = reshape(bsxfun(@times, yyp, permute(xxp, [1 3 2])), ...
        [numel(data) (np+1)^2]);

    %% Fit betas
    val = ~isnan(data);
    beta = xyp(val,:) \ data(val);

    %% Compute fitted
    fitted = reshape(xyp * beta, dims);

end