%% get_params - return a struct of key-value pairs
% Gordon Bean, January 2012
%
% Usage
% params = get_params( ... )
%
% Used to parse key-value pairs in varargin - returns a struct.
% Converts all keys to lower case.

% (c) Gordon Bean, August 2013

function params = get_params( varargin )
    params = struct;
    
    n = length(varargin);
    if (mod(n,2) ~= 0)
        error('Uneven number of parameters and values in list.');
    end
    
    tmp = reshape(varargin, [2 n/2]);
    for ii = 1 : size(tmp,2)
        params.(lower(tmp{1,ii})) = tmp{2,ii};
    end
        
%     params = struct;
%     params2 = struct(varargin{:});
%     for f = fieldnames(params2)'
%         params.(lower(f{1})) = params2.(f{1});
%     end
%     
end