% This function horizontally combines unequal length vectors and pads the
% shorter vector with NaNs
% Gordon Bean, May 2010

function [out] = nanpad (varargin)
    
    % Find the max size
    maxn = 0;
    for a = 1 : size(varargin,2)
        if (maxn < numel(varargin{a}))
            maxn = numel(varargin{a});
        end
    end
    
    % Produce output
    out = nan(maxn,size(varargin,2));
    for a = 1 : size(varargin,2)
        out(1:numel(varargin{a}),a) = varargin{a}(:);
    end

end % of nanpad