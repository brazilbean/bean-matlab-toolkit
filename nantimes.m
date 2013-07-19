% Gordon Bean, April 2011

function p = nantimes( A, B )

    p = nan(size(A,1),size(B,2));
    
    % Rows of A times columns of B
    for a = 1 : size(A,1)
        p(a,:) = nansum(bsxfun(@times, A(a,:)', B),1);
        ii = all(bsxfun(@plus, isnan(A(a,:)'), isnan(B)),1);
        p(a,ii) = nan;
    end

end