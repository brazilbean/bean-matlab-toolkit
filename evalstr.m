%% EVALSTR
% Gordon Bean, February 2012
% 
% Calls eval using sprintf format arguments

function evalstr( varargin )
    str = sprintf(varargin{:});
    fprintf('%s\n', str);
    evalin('caller', str);
    
end