%% Labels
% Gordon Bean, January 2011
% 
% Applies x and y labels in a default fontsize of 14.
%
% Usage
% labels( xlabel, ylabel, ... )
%
% All additional arguments are passed to the calls of xlabel and ylabel.

function labels (x, y, varargin)

    if (~isempty(varargin))
        xlabel(x, varargin{:});
        ylabel(y, varargin{:});
    else
        xlabel(x, 'fontsize', 14);
        ylabel(y, 'fontsize', 14);
    end

end