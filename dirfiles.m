%% Dirfiles - list filenames in dir
% Gordon Bean, May 2012

function files = dirfiles( dirfoo, str, keeppath )

    if (nargin < 3)
        keeppath = true;
    end
    
    if (nargin < 2)
        str = '';
    end
    
    if (dirfoo(end) ~= '/')
        dirfoo = [dirfoo '/'];
    end

    tmp = dir([dirfoo str]);
    files = {tmp.name}';
    files(cat(1,tmp.isdir)) = [];

    if (keeppath)
        for ii = 1 : length(files)
            files(ii) = {[dirfoo files{ii}]};
        end
    end
    
end