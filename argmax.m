%% Argmax
% Gordon Bean, May 2013

function mi = argmax(data,dim)
    if (nargin == 2 )
        [~,mi] = max(data,[],dim);
        mi(all(isnan(data),dim)) = nan;
    else
        [~,mi] = max(data);
        mi(all(isnan(data))) = nan;
    end
    
end