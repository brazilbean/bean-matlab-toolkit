%% Default param
% Gordon Bean, March 2012

% (c) Gordon Bean, August 2013

function params = default_param( params, varargin )
    if (iscell(params))
        params = get_params(params{:});
    end
    defaults = get_params(varargin{:});
    
    for f = fieldnames(defaults)'
        field = f{:};
        if (~isfield( params, lower(field) ))
            params.(lower(field)) = defaults.(field);
        end
    end
end