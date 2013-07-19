%% Point_correlation
% Gordon Bean, October 2011

function [pc tmpa tmpr] = point_corr(x, y, option)

    xsize = size(x);
    
    if(nargin > 2 && strcmp('center',option))
        x = x - nanmean(x(:));
        y = y - nanmean(y(:));
    end
    
    if (nargin > 2 && strcmp('zscore',option))
        x = nanzscore(x(:));
        y = nanzscore(y(:));
    end
    
    if (nargin > 2 && strcmp('spearman',option))
        [~,xo] = sort(x(:));
        [~,xr] = sort(xo);
        
        [~,yo] = sort(y(:));
        [~,yr] = sort(yo);
        
        x2 = xr - nanmean(xr);
        x2(isnan(x)) = nan;
        x = x2;
        
        y2 = yr - nanmean(yr);
        y2(isnan(y)) = nan;
        y = y2;
    end
        
    tmp = [x(:) y(:)];
    
    % Angle
    theta = -pi/4;
    rot = [ cos(theta) -sin(theta);
            sin(theta) cos(theta)];
    
    tmp2 = tmp * rot;
    
    tmpa = atan2(tmp2(:,1), tmp2(:,2));
    tmpa = abs( mod(tmpa, pi) - pi/2 ) / (pi/2);
    tmpa = (tmpa - 0.5) / 0.5;
    
    % Radius
    tmpr = sqrt( x(:).^2 + y(:).^2 );
    
    pc = tmpa .* tmpr;% ./ nansum(tmpr);
    pc = reshape( pc, xsize );
    tmpa = reshape( tmpa, xsize );
    tmpr = reshape( tmpr, xsize );
    
end