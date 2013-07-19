%% nanspearman - nan-ignoring spearman correlation
% Function for calculating the correlation when nans are present
% Gordon Bean, September 2009, May 2010
%
% See help for NANCORRCOEF for details.

function [coef stats] = nanspearman( data1, data2 )
    data1 = double(data1);
    if (nargin == 2)
        data2 = double(data2);
        
        if (nargout > 1)
            [coef stats] = nanspearman([data1(:) data2(:)]);
        else
            coef = nanspearman([data1(:) data2(:)]);
        end
        coef = coef(2);
        
    else
        coef = nan(size(data1,2));
        for a = 1 : size(data1,2)
            coef(:,a) = corr_pair(data1,a);
        end

        % Remove scores with less than 3 data points
        counts = double(~isnan(data1))' * ~isnan(data1);
        if (nargout > 1)
            % Return counts and don't filter
        else
            coef(counts<3) = nan;
        end
    
        if (nargout > 1)
            alpha = 0.05;
            z = 0.5 * log( (1+coef)./(1-coef) );
            zalpha = nan(size(coef));
            if ( any(counts(:)>3) )
                ii = counts > 3;
                zalpha(ii) = (-erfinv(alpha - 1)) .* sqrt(2) ...
                    ./ sqrt(counts(ii)-3);
            end
            stats.lower = zeros(size(coef));
            stats.lower = tanh( z - zalpha );
            stats.lower(eye(size(coef))==1) = nan;

            stats.upper = zeros(size(coef));
            stats.upper = tanh( z + zalpha );
            stats.upper(eye(size(coef))==1) = nan;

            stats.error = coef - stats.lower;
            stats.counts = counts;
        end
    end
        
    function c = corr_pair( x, a )
        x(isnan(x(:,a)),:) = nan;
        xa = repmat(x(:,a),[1 size(x,2)]);
        xa(isnan(x)) = nan;
        x(isnan(xa)) = nan;
        
        % Rank values
        [~, tmp] = sort(x,1);
        [~, xr] = sort(tmp,1);
        xr(isnan(x)) = nan;
        
        [~, tmp] = sort(xa,1);
        [~, xar] = sort(tmp,1);
        xar(isnan(xa)) = nan;
        
        % Calculate Correlation on ranks
        x_ = bsxfun(@minus, xr, nanmean(xr,1));
        xa_ = bsxfun(@minus, xar, nanmean(xar,1));
        
        covxy = nansum( x_ .* xa_ );
        covxx = nansum( x_.^2 );
        covyy = nansum( xa_.^2 );
        
        c = covxy ./ sqrt(covxx .* covyy);
        
    end

end

% function coef = nanspearman (data1, data2) 
%     if (nargin < 2)
%         % Use the matrix version
%         
%         [~, order] = sort(data1);
%         [~, ranks] = sort(order);
% 
%         ranks(isnan(data1)) = nan;
%         coef = nancorrcoef(ranks);
% %         coef = nan(size(data1));
% %         for a = 1 : N
% %             for b = a + 1 : N
% %                 nanmask = ~isnan(data1(:,a) & ~isnan(data1(:,b));
% %                 n_ = sum(nanmask);
% %                 coef(a,b) = 1 - 6 * sum((ranks(:,a) - ranks(:,b)).^2 .* nanmask) ...
% %                     / (n_*(n_^2-1));
% % 				coef(b,a) = coef(a,b);
% % 			end
% % 		end
% %         
%     else 
%         % Use the vector version
%         coef = nanspearman([data1(:) data2(:)]);
% %         
% %         [r c] = size(data1);
% %         if (c > r)
% %             data1 = data1';
% %         end
% %         [r c] = size(data2);
% %         if (c > r)
% %             data2 = data2';
% %         end
% % 
% %         tmp = [data1 data2];
% %         tmp(isnan(data1) | isnan(data2),:) = [];
% % 
% %         if (isempty(tmp))
% %             coef = NaN;
% %         else
% %             coef(1) = corr(tmp(:,1),tmp(:,2));
% %         end
%     end
% end
