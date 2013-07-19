%% Qcircle - quick circle
% Gordon Bean, May 2012

function h = qcircle(x, y, r, varargin)

    h = rectangle('Position',[x-r, y-r, 2*r, 2*r],'Curvature',[1 1], ...
        varargin{:});
    if(nargout < 1)
        clear h;
    end

end