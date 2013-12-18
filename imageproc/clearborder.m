%% Clearborder - remove connected components that touch the image border
% Gordon Bean, December 2013

function im = clearborder(img)

    % Add empty border around image
    [m,n] = size(img);
    img = [false false(1,n) false
           false(m,1) img false(m,1)
           false false(1,n) false ];
%     orig_inds = zeros([m,n]+2);
%     orig_inds(2:end-1,2:end-1) = reshape(1 : prod([m, n]),[m,n]);
    
    border = false(size(img));
    border([2 end-1],2:end-1) = true;
    border(2:end-1,[2 end-1]) = true;
    
    % Set up visited, etc.
    nix_label = true;
%     indices = zeros(numel(img),1);
    nix = false(size(img));
    comp_end = 1;
    
    visited = false(size(img));
    queue = zeros(numel(img),1);
    queue_pos = 1;
    queue_end = 1;
    
    [m, n] = size(img);
    
    % Define neighbor function
    neighbors = in(bsxfun(@plus, (-1:1)', (-1:1)*m),@(x) x ~= 0);
    
    % Single pass through image
    for master_pos = find(border & img)'
        
        % Is current pixel un-visited foreground?
        if ~visited(master_pos)
            % Pixel is foreground - add to queue
            queue(queue_end) = master_pos;
            queue_end = queue_end + 1;
            
            % Mark as visited
            visited(master_pos) = true;
    
            % Process positions
            while queue_pos < queue_end
                pos = queue(queue_pos);
                queue_pos = queue_pos + 1;
                
                % Assign label
                nix(pos) = nix_label;
%                 indices(comp_end) = orig_inds(pos);
                comp_end = comp_end + 1;

                % Get all non-visited, foreground neighbors
                nbrs = pos + neighbors;
                nbrs = nbrs(~visited(nbrs) & img(nbrs));

                % Add neighbors to queue
                queue(queue_end + (0 : numel(nbrs)-1)) = nbrs;
                queue_end = queue_end + numel(nbrs);

                % Mark neighbors as visited
                visited(nbrs) = true;
                
            end
            
        else
            % Background pixel, keep going
        end
    end
%     indices = indices{cur_label}(1:comp_end-1);
    im = img & ~nix;
    im = im(2:end-1,2:end-1);

end