%% Hierarchical Heatmap
% Plot a heatmap arrange in an optimal-leaf-ordered hierarchy

function [tmpo_ tmpz] = hierarchical_heatmap( data, varargin )
    
    params = get_params(varargin{:});
    for f = {'imagescargs','linkage','leaforder'}
        if (~isfield(params, f{1}))
            params.(f{1}) = {};
        end
    end
    if (~isfield(params, 'imagesc'))
        if (any(isnan(data(:))))
            params.imagesc = @imagescnan;
            if (~ismember('nancolor', params.imagescargs))
                params.imagescargs = ...
                    [params.imagescargs {'nancolor', 0.8 * [1 1 1]}];
            end
        else
            params.imagesc = @imagesc;
        end
    end
    
    if (~isfield( params, 'doplot'))
        params.doplot = 1;
    end
    if (~isfield( params, 'corr'))
        if (~any(isnan(data(:))))
            corrfun = @corrcoef;
        else
            corrfun = @nancorrcoef;
        end
        if ( size(data,1) == size(data,2) )
            corr = corrfun( data );
        else 
            corr = {corrfun(data'), corrfun(data)};
        end
    else
        corr = params.corr;
    end
    
    if (~iscell(corr))
        % Symmetric matrix
        tmpc = corr;
        tmpc(isnan(tmpc)) = 0;
        tmpc(eye(size(tmpc))==1) = 1;

        tmpd = squareform( 1 - tmpc );
        tmpz = linkage( tmpd, params.linkage{:} );

        tmpo = optimalleaforder(tmpz, tmpd, params.leaforder{:});

        if (params.doplot)
            imagescnan( data(tmpo,tmpo), params.imagescargs{:} );
        end
    else
        % Order both sides separately
        % corr = {dim1_corr, dim2_corr}
        tmpo = cell(2,1);
        for c = 1 : 2
            tmpc = corr{c};
            tmpc(isnan(tmpc)) = 0;
            tmpc(eye(size(tmpc))==1) = 1;

            tmpd = squareform( 1 - tmpc );
            tmpz = linkage( tmpd, params.linkage{:} );

            tmpo{c} = optimalleaforder( tmpz, tmpd, params.leaforder{:} );
        end
        
        if (params.doplot)
            params.imagesc ...
                ( data(tmpo{1},tmpo{2}), params.imagescargs{:} );
        end
    end
    
    if (nargout > 0)
        tmpo_ = tmpo;
    end
end