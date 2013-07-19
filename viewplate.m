%% VIEWPLATE
% Gordon Bean, June 2011
% View colony size data in a rectangular "plate" format.
%
% Usage
% viewplate( data, ... )
%
% Parameters
% emap - logical = {0} | 1
%   Indicates if the data is in EMAP Toolkit order.
%
% style - string = {scatter} | imagesc
%   'scatter' uses colored scaled circles to represent colony sizes.
%   'imagesc' uses square patches of color to represent colony sizes.
%

function scat = viewplate (plate, varargin)

    params = get_params(varargin{:});
    params = default_param( params, 'colorbar', true );
    params = default_param( params, 'emap', false );
    params = default_param( params, 'style', 'circles' );
    params = default_param( params, 'notemarker', '\leftarrow' );

    newplot;
    
    % Find dimensions
    n = numel(plate);
    dims = [8 12] .* sqrt( n / 96 );
    
%     params = default_param( params, 'max_circ', round(prod(dims)/10) );
    if (~isfield( params, 'max_circ'))
        set(gca, 'units','pixels');
        pos = get(gca, 'position');
        set(gca, 'units','normalized');
        
        rad = min(floor(pos([4 3]) ./ 2 ./ dims));
        params.max_circ = floor(pi*rad^2);
    end
    
    % Reorder plate, if necessary
    if (params.emap)
        plate = in(reshape(plate, fliplr(dims))');
    end
    
    % Draw figure
    switch lower(params.style)
        case 'imagesc'
            nancolor = 0.9*[1 1 1];
            imagescnan( reshape( plate, dims ), 'nancolor', nancolor);
            
        case 'circles'
            xx = repmat( 1:dims(2), [dims(1) 1] );
            yy = repmat( (1:dims(1))', [1 dims(2)]);

            % 1 = min, max = 120
            max_circ =  params.max_circ;
            tmp = reshape( plate, dims );
            
            % Calculate Size of spots
            tmp_size = tmp;

            if (isfield(params, 'min_size'))
                min_size = params.min_size;
            else
                min_size = min(tmp(:));
            end
            
            tmp_size = tmp_size - min_size;
            tmp_size( tmp_size < 0 ) = 0;

            if (isfield(params, 'max_size'))
                max_size = params.max_size - min_size;
            else
                max_size = max(tmp_size(:));
            end
            tmp_size = tmp_size / max_size;
            tmp_size( tmp_size > 1 ) = 1;

            tmp_size = (max_circ-1) * tmp_size;

            scat.size = tmp_size(:) + 1;
            scat.color = tmp(:);

            scatter( xx(:), yy(:), scat.size, scat.color, 'filled');
            set(gca, 'ydir', 'reverse');
            xlim([0 max(xx(:))+1]);
            ylim([0 max(yy(:))+1]);
            
        otherwise
            error('Unsupported option: %s', params.style);
    end
    
    % Draw notes
    if (isfield( params, 'notes' ))
        if (islogical(params.notes))
            [yy xx] = ind2sub( dims, find(params.notes) );
        else
            [yy xx] = ind2sub( dims, params.notes );
        end
        text( xx, yy, params.notemarker, 'fontsize', 16, 'color', 'k' );
    end
    
    if (params.colorbar)
        colorbar;
    end
    
    if (nargout == 0)
        clear scat;
    end
end