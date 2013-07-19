%% get_sym_indexes - find the indexes representing the intersection
% This function returns the indexes of values shared between two sets
% Gordon Bean, July 2010, February 2012
%
% Usage
% get_sym_indexes( set1, set2 )
% [inds1 inds2 top] = get_sym_indexes( ... )
% 
% 'top' returns a logical matrix indicating the upper triangle of the
% symmetric matrix indicated by 'inds1' and 'inds2'.
%
% Example
% Compare the symmetric replicates in an asymetric data matrix
% >> rowlabels = {'a','b','c','d','e'};
% >> collabels = {'a','d','e','c'};
% >> data = rand(length(rowlabels), length(collabels));
% >> [sr sc top] = get_sym_indexes( rowlabels, collabels );
% >> data(sr, sc)
% 
% ans =
% 
%       0.45174      0.63177      0.69643      0.42311
%      0.059403       0.1343      0.13015      0.72292
%       0.31581     0.098594     0.092352      0.53121
%       0.77272      0.14203    0.0078203      0.10882
% 
% >> [in(data(sr,sc),top), in(data(sr,sc)',top)]
% 
% ans =
% 
%       0.63177     0.059403
%       0.69643      0.31581
%       0.13015     0.098594
%       0.42311      0.77272
%       0.72292      0.14203
%       0.53121    0.0078203
% 

 
function [inds1 inds2 top] = get_sym_indexes( set1, set2 )
    [~, inds1, inds2] = intersect( set1, set2 );
    top = triu(ones(length(inds1)),1) == 1;
    
end

%% Old Code
% function [inds1 inds2 top] = get_sym_indexes ...
%                                 (set1, set2, exclude_duplicates)
%     if (nargin < 3)
%         exclude_duplicates = 0;
%     end
% 
%     % Check for duplicates
%     if (~exclude_duplicates && numel(union(set1,[])) ~= numel(set1))
%         error('Set1 has duplicates. Please remove the duplicates');
%     end
%     if (~exclude_duplicates && numel(union(set2,[])) ~= numel(set2))
%         error('Set2 has duplicates. Please remove the duplicates');
%     end
%     
%     inds1 = nan(length(shared_set),1);
%     inds2 = nan(length(shared_set),1);
%     
%     for a = 1 : length(shared_set)
%         inds1(a) = find(strcmp(shared_set{a}, set1), 1, 'first');
%         inds2(a) = find(strcmp(shared_set{a}, set2), 1, 'first');
%         
%     end
% 
%     if (nargout > 2)
%         top = triu(ones(length(inds1)),1) == 1;
%     end
%     
% end % of get_sym_indexes 