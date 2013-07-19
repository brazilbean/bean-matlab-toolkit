%% CORR3 - computes a 3D equivalent of correlation
% Gordon Bean, July 2011
%
%

function c = corr3 (x, y, z)

    if (nargin == 3)
        foo = [x y z];
    else
        foo = x;
    end

    % Remove NaNs
    nix = any(isnan(foo),2);

    % QR
    [~, R] = qr( foo(~nix, :) );
    
    % Find angles
    R = R(1:3,:);
    a = R(:,1) ./ norm(R(:,1));
    b = R(:,2) ./ norm(R(:,2));
    ab = (a + b) ./ norm(a + b);
    c = R(:,3) ./ norm(R(:,3));

    area = 4 * acos(dot(a,b)) * acos(dot(ab,c)) / pi^2;

    c = 1 - area;


end