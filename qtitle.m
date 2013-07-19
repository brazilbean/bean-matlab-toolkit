%% QTITLE - quick title
% Gordon Bean, January 2012
% 
% Prints the title with fonstize 16, using fprintf format

function h = qtitle( string, varargin )
    h = title( sprintf(string, varargin{:}), 'fontsize', 16);
    if (nargout < 1)
        clear h;
    end
end

