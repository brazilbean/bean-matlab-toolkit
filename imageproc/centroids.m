%% Centroids - find the centroids of connected components in a binary image
% Gordon Bean, August 2013

function middles = centroids(img, inds)
    % Label the components
    if nargin < 2
        inds = label_components(img);
    end
    
    % Compute centroids
    middles = nan(length(inds),2);
    for ii = 1 : length(inds)
        [rows, cols] = ind2sub(size(img), inds{ii});
        middles(ii,:) = [mean(cols), mean(rows)];
    end
end