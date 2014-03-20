%% EVALSTR
% Gordon Bean, February 2012
% 
% Calls eval using sprintf format arguments

function out = evalstr( varargin )
    str = sprintf(varargin{:});
    fprintf('%s\n', str);
    evalin('caller', str);
%     out = evalin('caller', str);
    out = {};
    if nargout == 0
        clear out;
    end
end