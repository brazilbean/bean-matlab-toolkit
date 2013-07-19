%% HEATSCATTER ( X, Y, resolution )
% Gordon Bean, August 2011
%
% 'resolution' sets the number of bins - may be scalar or two-element
% vector.

function [c s] = heatscatter (xx, yy, res)

    if (nargin < 3)
        res = [200,200];
    end
    
    if (numel(res) == 1)
        res = res * [1 1];
    end
    
    N = hist3( [xx, yy], res);
    N(N==0) = nan;
    
    x = linspace( min(xx), max(xx), res(1));
    y = linspace( min(yy), max(yy), res(2));
    
    imagescnan(x, y, N, 'nancolor', [1 1 1]);
    set(gca,'YDir','normal')

    if (nargout >= 1)
        c = nancorrcoef( xx, yy );
        
        if (nargout == 2)
            s = slope( xx, yy );
        end
    end
end