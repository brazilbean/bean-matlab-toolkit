%% Nancorr
% Gordon Bean, December 2012

function nc = nancorr( data1, data2 )

    if (nargin == 1)
        nc = nancorrcoef( data1 );
        return;
    end
    
    % Match first dimension
    dims1 = size(data1);
    dims2 = size(data2);
    
    nc = nan([dims1(2:end) dims2(2:end)]);
    
    % Compute correlation between pairs of columns
    data1 = reshape( data1, [dims1(1) prod(dims1(2:end))]);
    data2 = reshape( data2, [dims2(1) prod(dims2(2:end))]);
    
    for ii = 1 : prod(dims1(2:end))
        for jj = 1 : prod(dims2(2:end))
            kk = sub2ind( [prod(dims1(2:end)) prod(dims2(2:end))], ii,jj );
            nc(kk) = nancorrcoef( data1(:,ii), data2(:,jj) );
        end
    end

end