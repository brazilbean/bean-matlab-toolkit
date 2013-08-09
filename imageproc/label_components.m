%% Label Components - label the connected components in a binary image
% Gordon Bean, August 2013

function [indices, labels] = label_components(img)
    % Add empty border around image
    [m,n] = size(img);
    img = [false false(1,n) false
           false(m,1) img false(m,1)
           false false(1,n) false ];
    orig_inds = zeros([m,n]+2);
    orig_inds(2:end-1,2:end-1) = reshape(1 : prod([m, n]),[m,n]);
    
    % Set up label, visited, etc.
    cur_label = 1;
    labels = zeros(size(img));
    indices = cell(fix(numel(img)/2),1);
    comp_end = 1;
    
    visited = false(size(img));
    queue = zeros(numel(img),1);
    queue_pos = 1;
    queue_end = 1;
    
    [m, n] = size(img);
    
    % Define neighbor function
    neighbors = in(bsxfun(@plus, (-1:1)', (-1:1)*m),@(x) x ~= 0);
%     as_subs = @(index, fun) ...
%         apply(mod(index-1,m)+1, fix((index-1)/m)+1, fun);
%     valid = @(index, nn) nn > 0 & ...
%         as_subs(index, @(row, col) ...
%         as_subs(nn, @(nrow, ncol) ...        
%         nrow > 0 & nrow <= m & abs(nrow-row) < 2 & ...
%         ncol > 0 & ncol <= n & abs(ncol-col) < 2 ));
    
    % Single pass through image
    for master_pos = find(orig_inds>0 & img)'
        
        % Is current pixel un-visited foreground?
        if ~visited(master_pos)
            % Pixel is foreground - add to queue
            queue(queue_end) = master_pos;
            queue_end = queue_end + 1;
            
            % Mark as visited
            visited(master_pos) = true;
    
            % Set up cell array
            indices{cur_label} = zeros(numel(img),1);
            
            % Process positions
            while queue_pos < queue_end
                pos = queue(queue_pos);
                queue_pos = queue_pos + 1;
                
                % Assign label
                labels(pos) = cur_label;
                indices{cur_label}(comp_end) = orig_inds(pos);
                comp_end = comp_end + 1;

                % Get all non-visited, foreground neighbors
%                 nbrs = in(pos + neighbors, valid(pos, pos+neighbors));
%                 nbrs = in(nbrs, @(x) ~visited(x) & img(x));
                nbrs = pos + neighbors;
                nbrs = nbrs(~visited(nbrs) & img(nbrs));

                % Add neighbors to queue
                queue(queue_end + (0 : numel(nbrs)-1)) = nbrs;
                queue_end = queue_end + numel(nbrs);

                % Mark neighbors as visited
                visited(nbrs) = true;
                
            end
            
            % Increment label
            indices{cur_label} = indices{cur_label}(1:comp_end-1);
            comp_end = 1;
            
            cur_label = cur_label + 1;
            
            
        else
            % Background pixel, keep going
        end
    end
    
    indices = indices(1:cur_label-1);
    if nargout > 1
        labels = labels(2:end-1,2:end-1);
    end
    
%     % Set up label, visited, etc.
%     cur_label = 1;
%     labels = zeros(size(img));
%     visited = false(size(img));
%     queue = zeros(numel(img),1);
%     queue_pos = 1;
%     queue_end = 1;
%     
%     [m, n] = size(img);
%     
%     % Define neighbor function
%     filter = @(x,f) x(f(x));
%     
%     % Valid rows
%     neighbor_rows = @(index) apply(mod(index-1,m)+1, @(index) ...
%         filter([-1 0 1]', @(x) x + index > 0 & x + index <= m));
%     % Valid columns
%     neighbor_cols = @(index) apply(fix((index-1)/m)+1, @(index) ...
%         filter([-1 0 1], @(x) x + index > 0 & x + index <= n));
%     % Linear index of valid neighbors
%     neighbors = @(index) index + filter(bsxfun(@plus, ...
%         neighbor_rows(index), neighbor_cols(index)*m), @(x) x ~= 0);
%     
%     % Single pass through image
%     for master_pos = 1 : numel(img)
%         % Is current pixel un-visited foreground?
%         if img(master_pos) && ~visited(master_pos)
%             % Pixel is foreground - add to queue
%             queue(queue_end) = master_pos;
%             queue_end = queue_end + 1;
%             
%             % Mark as visited
%             visited(master_pos) = true;
%     
%             % Process positions
%             while queue_pos < queue_end
%                 pos = queue(queue_pos);
%                 queue_pos = queue_pos + 1;
%                 
%                 % Assign label
%                 labels(pos) = cur_label;
% 
%                 % Get all non-visited, foreground neighbors
%                 nbrs = filter(neighbors(pos), @(x) ~visited(x) & img(x));
% 
%                 % Add neighbors to queue
%                 queue(queue_end + (0 : numel(nbrs)-1)) = nbrs;
%                 queue_end = queue_end + numel(nbrs);
% 
%                 % Mark neighbors as visited
%                 visited(nbrs) = true;
%                 
%             end
%             
%             % Increment label
%             cur_label = cur_label + 1;
%         else
%             % Background pixel, keep going
%         end
%     end
end