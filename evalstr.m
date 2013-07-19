%% EVALSTR
% Gordon Bean, February 2012
% 
% Calls eval using sprintf format arguments

function evalstr( varargin )
    evalin('caller', sprintf(varargin{:}));
    
end