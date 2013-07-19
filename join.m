% Gordon Bean, October 2010
% Join function, patterned after the PERL join function

function str = join (delim, list, varargin)
    if (nargin<2)
        error('join requires at least 2 arguments: delim, list');
    end
    
    if (length(list)==1 && ~iscell(list))
        list = {list};
    end
    
    if (length(list)==1 && nargin > 2)
        % values are passed as separate arguments
        list = [list varargin];
    elseif (length(list)==1 && nargin == 2)
        % Only one value, return it;
        str = list{:};
        return;
    else
        % All values are in the list
        if (strcmp(class(list),'double'))
            error('Numeric list values isn''t supported yet');
        end
    end
    
    format = ['%s' delim];
    str = [sprintf(format, list{1:end-1}) list{end}];
end
