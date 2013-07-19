%% achar - find strings in an array of strings
% Gordon Bean, November 2010
% "achar" = "find" in Portuguese
%
% Usage
% indexes = achar( strings_to_find, array_of_strings );
% indexes = achar( strings_to_find, array_of_strings, keep_nans );
% indexes = achar( strings_to_find, array_of_strings, keep_nans, ...
%                  findall );
% indexes = achar( strings_to_find, array_of_strings, keep_nans, ...
%                  findall, verbose );
%
% This function finds the indexes of each query in the population
% * strings_to_find can be a single string or a cell array of strings. 
%   These are the strings you want to find.
% * array_of_strings is a cell array of strings, representing the 
%   population of strings in which you are seeking the strings_to_find.
% * keep_nans is a boolean indicating whether to retain NaN values when
%   values in strings_to_find could not be found in array_of_strings.
% * findall is a boolean instructing ACHAR to find all occurrences of all
%   elements of 'strings_to_find' in 'array_of_strings'. Note that when
%   'findall' is true, keep_nans is ignored.
% * verbose is a boolean indicating whether to print a warning 
%   statement when values could not be found. 
% 
% Examples
% >> foo = {'one','two','three','one'}
% 
% foo = 
% 
%     'one'    'two'    'three'    'one'
% 
% >> achar('two', foo)
% 
% ans =
% 
%      2
% 
% >> achar({'one','three'}, foo)
% 
% ans =
% 
%      1     3
%
% >> achar({'three','four'}, foo)
% 
% ans =
% 
%      3
% 
% >> achar({'three','four'}, foo, 1)
% 
% ans =
% 
%      3   NaN
% 
% >> achar({'three','one'}, foo, 0, 1)
% 
% ans =
% 
%      3     1     4
% 

function inds = achar (queries, population, keepnans, findall, verbose)
    if (nargin < 5)
        verbose = 0;
    end
    if (nargin < 4)
        findall = 0;
    end
    if (nargin < 3)
        keepnans = 0;
    end
    if (~iscell(queries))
        queries = {queries};
    end

    if (~findall)
        inds = nan(size(queries));
        for a = 1 : numel(queries)
            tmp = find(strcmpi(queries{a},population));
            if (~isempty(tmp))
                inds(a) = tmp(1);
            else
                inds(a) = nan;
            end
        end
    else
        inds = nan(size(population));
        pos = 1;
        for a = 1 : numel(queries)
            tmp = find(strcmpi(queries{a},population));
            if (~isempty(tmp))
                inds(pos+(0:length(tmp)-1)) = tmp;
                pos = pos + length(tmp);
            else
                % Do nothing. You cannot report missing values and multiple
                % values at the same time.
            end
        end     
    end
    
    if verbose
        for a = find(isnan(inds))
            fprintf(2,'ACHAR: Could not find %s (%i)\n',queries{a},a);
        end
    end
    
    if (~keepnans || findall)
        inds(isnan(inds)) = [];
    end
    
end
