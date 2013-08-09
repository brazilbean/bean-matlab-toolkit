%% Component props - find the area and centroids of connected components
% Gordon Bean, August 2013

function [centroid, area] = component_props(img)

    % Find component labels
    inds = label_components(img);
    
    % Find Area
    area = cellfun(@length, inds);
    
    % Find Centroids
    centroid = centroids(img, inds);

end