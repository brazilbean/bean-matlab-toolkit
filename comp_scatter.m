% Gordon Bean, March 2011

function [c s] = comp_scatter(x, y, varargin)
    
    if (length(x) ~= length(y) && (length(x) ~= 1 && length(y) ~= 1))
        error('comp_scatter: Lengths of x and y should be equal or 1.');
    end
    
    N = max(length(x),length(y));
    
    xi = ones(1,N) .* (1:length(x));
    yi = ones(1,N) .* (1:length(y));

    c = nan(N,1);
    s = nan(N,2);
    for a = 1 : N
        if (nargin < 3)
            [c(a,1) s(a,:)] = uberscat(x{xi(a)},y{yi(a)});
        else
            scatter(x{xi(a)},y{yi(a)},varargin{:});
            c(a,1) = nancorrcoef( x{xi(a)}, y{yi(a)} );
            s(a,:) = slope( x{xi(a)}, y{yi(a)} );
        end
        hold on;
    end
    hold off;
end