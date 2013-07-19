%% Density Mode
% Gordon Bean, May 2011
%
% A NaN-ignoring continuous mode function based on density.

function md = dmode( data, dim, w )

    if (nargin < 2)
        dim = 1;
    end
    if (nargin < 3)
        w = floor(size(data,dim)/20);
    end
    
    dims = 1:length(size(data));
    dimord = [dim setdiff(dims,dim)];
    datap = permute(data, dimord);
    
    tmps = size(datap);
    tmps(1) = [];
    
    datap = reshape(datap, [size(datap,1) prod(tmps)]);
    
    [datasort, ord] = sort(datap,1);
    dens = nan(size(datap));
    dens(w+1:end-w,:) = ...
        (1+2*w) ./ (datasort(2*w+1:end,:) - datasort(1:end-2*w,:));
    
    [~,tmp] = max(dens,[],1);
    tmpi = sub2ind(size(datap), tmp, 1:size(datap,2));
    tmpi2 = sub2ind(size(datap), ord(tmpi), 1:size(datap,2));
    
    md = ipermute( reshape(datap(tmpi2),[1 tmps]) ,dimord);

end