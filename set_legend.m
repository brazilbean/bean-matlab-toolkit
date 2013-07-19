%% Set Legend Text Properties
% Gordon Bean, March 2013

function h = set_legend( varargin )
    
    h = findobj(gcf,'Type','axes','Tag','legend');
    set( findobj(h,'type','text'), varargin{:} );
    
    if (nargout < 1)
        clear h;
    end

end