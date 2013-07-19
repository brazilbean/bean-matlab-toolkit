%% Density Scatter
% Gordon Bean, March 2013

function [cc ss] = denscat( foo1, foo2, rad, sz )
    if (nargin < 4)
        sz = 20;
    end
    if (nargin < 3)
        rad = 0.1;
    end
    foo = [foo1(:), foo2(:)];
    
    foodist = sqrt(sum(bsxfun ...
    (@minus, permute(foo, [3 1 2]), permute(foo, [1 3 2])).^2,3));
    area = pi*rad^2;
    foodens = sum(foodist < rad)./area;
    [foodens, ord] = sort(foodens, 'descend');
    
    % Scatter
    [cc ss] = uberscat( foo1(ord), foo2(ord), sz, foodens, 'filled' );
    
end