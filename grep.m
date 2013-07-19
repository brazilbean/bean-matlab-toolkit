% GREP - searches for PATTERN in STRING
%  Returns MATCHES and INDEXES
%  MATCHES is a cell array of each string in STRING that matched PATTERN
%  INDEXES is an array of the index of each matching string
%
%  STRING may be a single string or a cell array of strings.
%  PATTERN may only be a string, not an array
%
%  OPTION is currently only defined for 'ignorecase', which conducts a
%  search that is case insensitive. Other values are ignored. 
%
%  This function runs on MATLAB's regexp function. 
%
%  See also REGEXP, REGEXPI, FIND, CELLFUN.
%
% Gordon Bean, January 2011

function [matches, indexes] = grep (pattern, string, option) 

    if (nargin > 2 && strcmpi(option,'ignorecase'))
        tmp = regexpi(string, pattern, 'match');
    else
        tmp = regexp(string, pattern, 'match');
    end
    
    indexes = find(~ cellfun(@isempty, tmp) );
    if (iscell(string))
        matches = string(indexes);
    elseif (ischar(string))
        matches = in({string}, indexes);
    end
    
end % of grep