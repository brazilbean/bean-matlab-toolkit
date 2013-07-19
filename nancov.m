% Function for calculating the correlation when nans are present
% Gordon Bean, September 2009, May 2010, November 2010, February 2011
% Note: November edit inspired by Matan Hofree

function [coef, counts] = nancov(data1, data2)

    if (nargin == 2)
        coef = nancov([data1(:) data2(:)]);
        coef = coef(2);
    else
        coef = nan(size(data1,2));
        for a = 1 : size(data1,2)
            coef(1:a,a) = corr_pair(data1(:,1:a),data1(:,a));
        end
        coef = nanmean(cat(3, coef, coef'),3);
        
        % Remove scores with less than 3 data points
        counts = double(~isnan(data1))' * ~isnan(data1);
        if (nargout > 1)
            % Return counts and don't filter
        else
            coef(counts<3) = nan;
        end

    end
    
    function c = corr_pair( x, a )
        x(isnan(a),:) = nan;
        xa = repmat(a,[1 size(x,2)]);
        xa(isnan(x)) = nan;
        
        x_ = bsxfun(@minus, x, nanmean(x,1));
        xa_ = bsxfun(@minus, xa, nanmean(xa,1));
        
        c = nansum( x_ .* xa_ ) ./ (sum(~isnan(xa)) - 1);
        
    end

end % of nancorrcoef

% function [coef,counts] = nancorrcoef (data1, data2) 
%     if (nargin < 2)
% %         coef = nancorrcoef_c(data1');
%         
%         % For compiling:
%         % mex CFLAGS="$CFLAGS -std=c99 -fPIC" ../../mfiles/nancorrcoef_c.c
%         
%         coef = nan(size(data1,2));
%         for a = 1 : size(data1,2)
%             coef(:,a) = nancorr_pair(data1,a);
%         end
%         
%         % Remove scores with less than 3 data points
%         counts = double(~isnan(data1))' * ~isnan(data1);
%         if (nargout > 1)
%             % Return counts and don't filter
%         else
%             coef(counts<3) = nan;
%         end
%         
% %         coef = nan(size(data1));
% %         for a = 1 : size(data1,2)
% %             fun = @(x)( in( nancorrcoef(data1(a,:),data1(x,:)) ,2) );
% %             coef(a,:) = arrayfun( fun, 1:size(data1,2) );
% %         end
%         
% %         % Use the matrix version
% %         tmp = data1;
% %         tmpm = nanmean(data1,1);
% %         tmpm2 = ones(size(tmp,1),1)*tmpm;
% %         tmp(isnan(tmp)) = tmpm2(isnan(tmp));
% %         coef = corrcoef(tmp);
% %         
% 
% %         zx = nanzscore(data1);
% %         notnans = ~isnan(zx)*1;
% %         zx(isnan(zx)) = 0;
% %         coef = (zx' * zx) ./ (notnans' * notnans - 1);
% %         coef(isinf(coef)) = nan;
% %         
%         
% %         coef = nan(size(data1,2));
% %         cdata = num2cell(data1,1);
% %         parfor a = 1:size(data1,2)
% %             nanzprod = @(x) (dot( zscore(x(~isnan(x)&~isnan(cdata{a}))), ...
% %                                zscore(cdata{a}(~isnan(x)&~isnan(cdata{a}))) ) );
% %     
% %             coef(:,a) = cellfun(nanzprod, cdata);
% %         end
% % %         
% %         x = data1;
% %         x0 = data1; x0(isnan(data1)) = 0;
% %         xb = double(~isnan(data1));
% %         n = (xb' * xb);
% %         xbar = (x0' * xb) ./ n; xbar(isnan(xbar)) = 0;
% %         xdiff = nan(size(data1,2));
% %         for a = 1 : size(data1,2)
% %             tmp = bsxfun(@minus,x,xbar(:,a)').^2;
% %             tmp(isnan(tmp)) = 0;
% %             xdiff(:,a) = tmp' * xb(:,a);
% %         end
% %         xsig = sqrt( xdiff ./ (n - 1) );
% %         xsig(isinf(xsig)) = 1;
% %         xsig(~isreal(xsig)) = 1;
% %         
% %         coef = (x0' * x0 - xbar.*(x0' * xb) - ...
% %             xbar'.*(x0' * xb)' + n.*xbar.*xbar') ./ ...
% %             ( (n-1) .* xsig .* xsig');
% %         
% %         coef = nan(size(data1,2));
% %         for a = 1 : size(data1,2)
% %             for b = a  : size(data1,2)
% %                 mask = ~isnan(data1(:,a)) & ~isnan(data1(:,b));
% %                 coef(a,b) = (nanzscore(data1(mask,a))' * ...
% %                             nanzscore(data1(mask,b)) )./ ...
% %                             (sum(mask)-1);
% %                 coef(b,a) = coef(a,b);
% %             end
% %         end
% %       
% 
% %         coef = nan(size(data1,2));
% %         for a = 1 : size(data1,2)
% %             mask = bsxfun(@and, ~isnan(data1) , ~isnan(data1(:,a)));
% %             nmask = nan(size(mask)); nmask(mask) = 0;
% %             tmp = nanzscore(data1 + nmask);
% %             tmpN = tmp;
% %             tmpN(isnan(tmp)) = 0;
% %             
% %             coef(a,:) = (tmpN' * tmpN(:,a)) ./ (~isnan(tmp)' * double(~isnan(tmp(:,a))) - 1);
% %         end
% %         coef = (x0' * x0 - xbar' * (x0'*xb) - xbar * (xb'*x0) + n.*(xbar'*xbar)) ...
% %             ./ (n .* xsig .* xsig');
% 
%     else 
%         % Use the vector version
% %         coef = nancorrcoef([data1(:) data2(:)]);
% 
%         foo = [data1(:) data2(:)];
%         foo(sum(isnan(foo),2)>0,:) = [];
%         coef = corrcoef(foo);
%         
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
%     
%     
% end