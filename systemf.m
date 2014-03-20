%% SYSTEMF - Execute formated string as system call
% Gordon Bean, March 2014
%
% Syntax
% systemf(FORMAT, ...)
% [status, result] = systemf(...)
%
% Description
% SYSTEMF(FORMAT, ... ) constructs a string by passing the FORMAT string
% and additional arguments to SPRINTF. The result is passed to SYSTEM. In
% essence: SYSTEM(SPRINTF(FORMAT,...));
%
% [STATUS, RESULT] = SYSTEMF(...) returns the STATUS and RESULT values
% returned from the call to SYSTEM.
%
% Example
% file = 'a_sample_file.txt';
% [~, output] = systemf('wc -l %s', file);
%
% See also system, sprintf

function [status, result] = systemf( format, varargin )
    [status, result] = system( sprintf(format, varargin{:}) );
    if nargout == 0
        clear status result;
    end
end