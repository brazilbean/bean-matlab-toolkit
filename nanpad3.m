% This function combines unequally sized matrixes and pads the
% smaller matrixes with NaNs
% Gordon Bean, October 2010

function [out] = nanpad3 (varargin)
    
    % Find the max size
    maxL = 0;
    maxW = 0;
    for a = 1 : size(varargin,2)
        if (maxL < size(varargin{a},1))
            maxL = size(varargin{a},1);
        end
        if (maxW < size(varargin{a},2))
            maxW = size(varargin{a},2);
        end
    end
    
    % Produce output
    out = nan(maxL,maxW,size(varargin,2));
    for a = 1 : size(varargin,2)
        out(1:size(varargin{a},1),1:size(varargin{a},2),a) = varargin{a};
    end

end % of nanpad