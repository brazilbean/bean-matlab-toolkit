%% Argmax
% Gordon Bean, May 2013

function mi = argmax(data,dim)
    if (nargin == 2 )
        [~,mi] = max(data,[],dim);
    else
        [~,mi] = max(data);
    end
end