%% Argmin 
% Gordon Bean, May 2013

function mi = argmin(data, dim)
    if nargin == 2
        [~,mi] = min(data,[],dim);
    else
        [~,mi] = min(data);
    end
end
