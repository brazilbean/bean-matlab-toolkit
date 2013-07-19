%% Jitter
% Gordon Bean, January 2013
%
% Adds a random jitter to the values

function data = jitter( data, scale, rfun )
    if (nargin < 2)
        scale = 1;
    end
    if (nargin < 3)
%         rfun = @(x)rand(x)-0.5;
        rfun = @randfun;
        
    end
    
    data = data + scale*rfun(size(data));

    function x = randfun( input )
        x = randn(input)./3;
        x = min( abs(x), 0.95 ) .* sign(x);
    end
end