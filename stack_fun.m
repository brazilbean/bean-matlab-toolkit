%% Stack fun - execute a list of functions together as a single function
% Gordon Bean, July 2013

function out = stack_fun( varargin )

    out = cellfun(@(x) x(), varargin, 'uniformOutput', false);

end