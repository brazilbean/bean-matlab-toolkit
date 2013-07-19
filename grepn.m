%% Grep -n
% Gordon Bean, April 2012

function ind = grepn( varargin )
    [~,ind] = grep( varargin{:} );
end