%% nancorrcoef - calculate the pairwise correlation ignoring nans
% Gordon Bean, September 2009, May 2010, November 2010, February 2011, 
%  February 2012
%
% Note: November edit inspired by Matan Hofree
%
% Pvalue and confidence interval code taken from corrcoeff.m
%
% Usage
% nancorrcoef( data1 );
% nancorrcoef( data1, data2 );
% [coef stats] = nancorrcoef( ... );
%
% When one argument is provided, NANCORRCOEF calculates the pairwise
% correlation of the columns of 'data1'.
% When two arguments are provided, NANCORRCOEF calculates the correlation
% between the vectorized 'data1' and 'data2'.
%
% When one argument is provided, 'coef' is the correlation matrix. When two
% arguments are provided, 'coef' is the correlation coefficient of the
% pair.
% 'stats' is a struct with the following fields:
% * lower - lower bound on confidence interval of alpha = 0.05
% * upper - upper bound on confidence interval of alpha = 0.05
% * error - the mean minus the lower bound
% * counts - the number of data points used to calculate the correlation
% * pvals - the p-values of the pairwise correlations
%
% Examples
% >> foo = rand(100,3);
% >> foo( foo< 0.2 ) = nan;
% >> nancorrcoef(foo)
% 
% ans =
% 
%             1      0.21974     0.045443
%       0.21974            1       0.1801
%      0.045443       0.1801            1
% 


function [coef stats] = nancorrcoef( data1, data2 )
    data1 = double(data1);
    if (nargin == 2)
        data2 = double(data2);
        if (numel(data1) ~= numel(data2))
            error('Inputs are of unequal size');
        end
        
        if (nargout > 1)
            [coef_ stats] = nancorrcoef([data1(:), data2(:)]);
        else
            coef_ = nancorrcoef([data1(:), data2(:)]);
        end
        coef = coef_(2);
                
    else
        coef = nan(size(data1,2));
        for a = 2 : size(data1,2)
            coef(1:a-1,a) = corr_pair(data1(:,1:a-1),data1(:,a));
        end
		coef = nanmean(cat(3, coef, coef'),3);
        coef(eye(size(coef))==1) = 1;

        % Remove scores with less than 3 data points
        counts = double(~isnan(data1))' * ~isnan(data1);
        if (nargout > 1)
            % Return pvalues
            tstats = coef .* sqrt((counts - 2) ./ (1 - coef.^2));
            stats.pvals = 2 * tpvalue(-abs(tstats), counts - 2);
            
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
        
        covxy = nansum( x_ .* xa_ );
        covxx = nansum( x_.^2 );
        covyy = nansum( xa_.^2 );
        
        c = covxy ./ sqrt(covxx .* covyy);
        
    end

    function p = tpvalue(x,v)
        % TPVALUE Compute p-value for t statistic.
        % Taken from corrcoef.m

        normcutoff = 1e7;
        if length(x)~=1 && length(v)==1
           v = repmat(v,size(x));
        end

        % Initialize P.
        p = NaN(size(x));
        nans = (isnan(x) | ~(0<v)); % v == NaN ==> (0<v) == false

        % First compute F(-|x|).
        %
        % Cauchy distribution.  See Devroye pages 29 and 450.
        cauchy = (v == 1);
        p(cauchy) = .5 + atan(x(cauchy))/pi;

        % Normal Approximation.
        normal = (v > normcutoff);
        p(normal) = 0.5 * erfc(-x(normal) ./ sqrt(2));

        % See Abramowitz and Stegun, formulas 26.5.27 and 26.7.1.
        gen = ~(cauchy | normal | nans);
        p(gen) = betainc(v(gen) ./ (v(gen) + x(gen).^2), v(gen)/2, 0.5)/2;

        % Adjust for x>0.  Right now p<0.5, so this is numerically safe.
        reflect = gen & (x > 0);
        p(reflect) = 1 - p(reflect);

        % Make the result exact for the median.
        p(x == 0 & ~nans) = 0.5;

    end

end % of nancorrcoef

%% Pre February 2012
% function [coef, pvals, counts, bounds] = nancorrcoef(data1, data2, alpha)
%     data1 = double(data1);
%     if (nargin == 2)
%         data2 = double(data2);
%         coef = nancorrcoef([data1(:) data2(:)]);
%         coef = coef(2);
%         counts = sum(~isnan(data1(:)) & ~isnan(data2(:)));
%     else
%         coef = nan(size(data1,2));
%         for a = 2 : size(data1,2)
%             coef(1:a-1,a) = corr_pair(data1(:,1:a-1),data1(:,a));
%         end
% 		coef = nanmean(cat(3, coef, coef'),3);
%         coef(eye(size(coef))==1) = 1;
% 
%         % Remove scores with less than 3 data points
%         counts = double(~isnan(data1))' * ~isnan(data1);
%         if (nargout > 1)
%             % Return pvalues
%             tstats = coef .* sqrt((counts - 2) ./ (1 - coef.^2));
%             pvals = 2 * tpvalue(-abs(tstats), counts - 2);
%             
%             if (nargout > 3)
%                 if (nargin < 3)
%                     alpha = 0.05;
%                 end
%                 z = 0.5 * log( (1+coef)./(1-coef) );
%                 zalpha = nan(size(coef));
%                 if ( any(counts(:)>3) )
%                     ii = counts > 3;
%                     zalpha(ii) = (-erfinv(alpha - 1)) .* sqrt(2) ...
%                         ./ sqrt(counts(ii)-3);
%                 end
%                 bounds.lower = zeros(size(coef));
%                 bounds.lower = tanh( z - zalpha );
%                 bounds.lower(eye(size(coef))==1) = nan;
%                 
%                 bounds.upper = zeros(size(coef));
%                 bounds.upper = tanh( z + zalpha );
%                 bounds.upper(eye(size(coef))==1) = nan;
%                 
%             end
%         else
%             coef(counts<3) = nan;
%         end
% 
%     end
%     
%     function c = corr_pair( x, a )
%         x(isnan(a),:) = nan;
%         xa = repmat(a,[1 size(x,2)]);
%         xa(isnan(x)) = nan;
%         
%         x_ = bsxfun(@minus, x, nanmean(x,1));
%         xa_ = bsxfun(@minus, xa, nanmean(xa,1));
%         
%         covxy = nansum( x_ .* xa_ );
%         covxx = nansum( x_.^2 );
%         covyy = nansum( xa_.^2 );
%         
%         c = covxy ./ sqrt(covxx .* covyy);
%         
%     end
% 
%     function p = tpvalue(x,v)
%         % TPVALUE Compute p-value for t statistic.
%         % Taken from corrcoef.m
% 
%         normcutoff = 1e7;
%         if length(x)~=1 && length(v)==1
%            v = repmat(v,size(x));
%         end
% 
%         % Initialize P.
%         p = NaN(size(x));
%         nans = (isnan(x) | ~(0<v)); % v == NaN ==> (0<v) == false
% 
%         % First compute F(-|x|).
%         %
%         % Cauchy distribution.  See Devroye pages 29 and 450.
%         cauchy = (v == 1);
%         p(cauchy) = .5 + atan(x(cauchy))/pi;
% 
%         % Normal Approximation.
%         normal = (v > normcutoff);
%         p(normal) = 0.5 * erfc(-x(normal) ./ sqrt(2));
% 
%         % See Abramowitz and Stegun, formulas 26.5.27 and 26.7.1.
%         gen = ~(cauchy | normal | nans);
%         p(gen) = betainc(v(gen) ./ (v(gen) + x(gen).^2), v(gen)/2, 0.5)/2;
% 
%         % Adjust for x>0.  Right now p<0.5, so this is numerically safe.
%         reflect = gen & (x > 0);
%         p(reflect) = 1 - p(reflect);
% 
%         % Make the result exact for the median.
%         p(x == 0 & ~nans) = 0.5;
% 
%     end
% 
% end % of nancorrcoef

%% Really Old
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
