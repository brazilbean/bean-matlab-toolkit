%% Require Param
% Gordon Bean, March 2013

function require_param( params, name, method )
    if (nargin < 3)
        method = 'unknown method';
    end
    if (~isfield( params, name ))
        error('%s, required parameter: %s', method, name);
    end

end