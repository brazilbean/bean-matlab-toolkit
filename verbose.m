%% Verbose - print if true
% Gordon Bean, March 2012

function tt = verbose( flag, str, varargin )
    if (flag)
        fprintf(str, varargin{:});
    end
end