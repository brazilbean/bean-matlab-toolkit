%% KSMODE - compute the mode using ksdensity
% Gordon Bean, February 2014

function [center, res] = ksmode( data, dim, npoints )
    if nargin < 3
        npoints = 100;
    end
    
    % reshape data to operate on dim
    ndims = length(size(data));
    todim = [dim setdiff(1:ndims, dim)];
    
    data_ = permute(data, todim);
    sizes = size(data_);
    data_ = reshape( data_, [sizes(1) prod(sizes(2:end))]);
    
    [center, res] = deal(nan(1,size(data_,2)));
    for ii = 1 : size(data_,2)
        [center(ii), res(ii)] = ksmode_vector( data_(:,ii), npoints );
    end
    
    center = reshape( center, [1 sizes(2:end)] );
    center = ipermute( center, todim );
    
    res = reshape( res, [1 sizes(2:end)] );
    res = ipermute( res, todim );
    
    function [m, res] = ksmode_vector(data, npoints)
        if all(isnan(data))
            [m, res] = deal(nan);
            return;
        end
        
        % ksdensity
        [f, xi] = ksdensity(data, 'npoints', npoints);

        % mode
        m = xi(argmax(f));

        res = diff(xi([1 2]));
    end
end