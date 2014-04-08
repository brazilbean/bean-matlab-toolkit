%% SYSTEMF - Execute formated string as system call
% Gordon Bean, March 2014
%
% Syntax
% systemf(FORMAT, ...)
% [result, status] = systemf(...)
%
% Description
% SYSTEMF(FORMAT, ... ) constructs a string by passing the FORMAT string
% and additional arguments to SPRINTF. The result is passed to SYSTEM. In
% essence: SYSTEM(SPRINTF(FORMAT,...));
%
% [RESULT, STATUS] = SYSTEMF(...) returns the STATUS and RESULT values
% returned from the call to SYSTEM. The reordering of RESULT and STATUS is
% deliberate.
%
% Example
% file = 'a_sample_file.txt';
% output = systemf('wc -l %s', file);
%
% See also system, sprintf

function [result, status] = systemf( format, varargin )
    [status, result] = system( sprintf(format, varargin{:}) );
    if nargout == 0
        clear status result;
    end
end