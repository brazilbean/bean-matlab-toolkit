%% Uberscat - Scatter + correlation
% Gordon Bean, February 2011
%
% Plots the scatter of x1 and x2 and returns the Pearson and Spearman
% correlation of the same. The slope is also returned.
%
% If extra arguments are supplied, they are passed to 'scatter'. Otherwise,
% custom defaults are used.
%
% Example
% >> [ c s ] = uberscat( rand(100,1), rand(100,1) )
%

function [c, s, sl] = uberscat (x1, x2, varargin)

    if nargin > 2
        scatter(x1, x2, varargin{:});
    else
        scatter(x1, x2, 20, 'o','filled');
    end
    
    if (nargout > 0)
        c = nancorrcoef(x1, x2);
        if (nargout > 1)
%             s = slope(x1,x2);
            s = nanspearman( x1, x2 );
            
            if (nargout > 2)
                sl = slope( x1, x2 );
            end
        end
    end

end