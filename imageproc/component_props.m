%% Component props - find the area and centroids of connected components
% Gordon Bean, August 2013

function [centroid, area] = component_props(img, inds)

    % Find component labels
    if nargin < 2
        inds = label_components(img);
    end
    
    % Find Area
    area = cellfun(@length, inds);
    
    % Find Centroids
    centroid = centroids(img, inds);

end