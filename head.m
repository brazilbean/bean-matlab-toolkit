%% Head function
% Gordon Bean, June 2014

function out = head( arg, n )
    if nargin < 2
        n = 10;
    end
    
    if ischar(arg)
        % Assume head is a file name
        out = systemf('head -%i %s', n, arg);
    else
        out = arg(1:min(numel(arg),n));
    end

end