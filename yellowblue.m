function YB = yellowblue (m)
%YELLOWBLUE   Creates a yellow to blue colormap
%   YELLOWBLUE(M) creates a yellow to blue colormap. Yellow are upper
%   values, black are middle values, and blue are lower values. 

    if (nargin < 1)
        m = size(get(gcf,'colormap'),1);
    end

    YB = zeros(m,3);
    YB(floor(m/2)+1:m,1:2) = ...
        [1:floor(m/2); 1:floor(m/2)]'./ floor(m/2);
    YB(floor(m/2):-1:1,3) = (1:floor(m/2)) ./ floor(m/2);
    YB = YB.^0.8;
    
end