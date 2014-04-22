%% parzen_mode - calculate the mode using a gaussian kernel
% Gordon Bean, January 2012
% Central idea implemented by Sean Collins (2006) as part of the EMAP
% Toolkit.
%
% Usage
% parzen_mode( data )
% parzen_mode( data, dim )
%
% PARZEN_MODE calculates the mode across diminsion 'dim' (default is 1)
% using a gaussian kernal.

function center = parzen_mode( data, dim, width )
    if (nargin < 2)
        dim = find(size(data) ~= 1, 1, 'first');
    end
    if nargin < 3
        width = nan;
    end
    
    ndims = length(size(data));
    todim = [dim setdiff(1:ndims, dim)];
    
    data_ = permute(data, todim);
    sizes = size(data_);
    data_ = reshape( data_, [sizes(1) prod(sizes(2:end))]);
    
    center = nan(1,size(data_,2));
    for ii = 1 : size(data_,2)
        center(ii) = parzen_mode_vector( data_(:,ii), width );
    end
    
    center = reshape( center, [1 sizes(2:end)] );
    center = ipermute( center, todim );
    
    function center = parzen_mode_vector(list,width)
    % Written by Sean Collins (2006) as part of the EMAP toolkit.
    % Revised by Gordon Bean (2011)
    % Uses parzen window smoothing to estimate the peak of a distribution.

        if nargin < 2 || isnan(width)
    %         width=50;       %this is the default window width
            width = 1.06 * nanstd(list) * sum(~isnan(list))^(-0.2);
        end
        
        if (sum(~isnan(list)) == 0)
            center = NaN;
        elseif (sum(~isnan(list)) == 1)
            center = notnan(list);
        else
%             n = round(sqrt(sum(~isnan(list))));
            n = sum(~isnan(list));

            x0 = (min(list));
            xF = (max(list));
            if (mod(xF-x0,2) == 1)
                xF = xF + 1;
            end

            x = linspace(x0, xF, n);

            % Discretize data
            y = hist( list, x );

            % Convolve with standard normal
            g = normpdf( x - median(x), 0, width);
            score = conv( y, g );
            % score will be a vector of length 2*length(x) - 1

            % Find max
            list2 = find( score == max(score) );

            % Account for the shift from the convolution
            list2 = list2 - floor(length(g)/2);
            list2( list2 > length(x) ) = length(x);
            list2 = max(1, list2);
            
            % Return peak
            center = mean( x(list2) );
        end

    end

end

