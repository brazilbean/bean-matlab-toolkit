% Gordon Bean, March 2011

function [c s] = comp_scatter3(x, y, z, varargin)
    
    if (length(x) ~= length(y) && (length(x) ~= 1 && length(y) ~= 1))
        error('comp_scatter: Lengths of x and y should be equal or 1.');
    end
    
    N = max([length(x),length(y),length(z)]);
    
    xi = ones(1,N) .* (1:length(x));
    yi = ones(1,N) .* (1:length(y));
    zi = ones(1,N) .* (1:length(z));

    for a = 1 : N
        scatter3(x{xi(a)},y{yi(a)},z{zi(a)},varargin{:});
        hold on;
    end
    hold off;
end