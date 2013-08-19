%% Void - supress output of a function
% Gordon Bean, August 2013

function out = void(fun)
    fun();
    if nargout > 0
        out = [];
    end
end