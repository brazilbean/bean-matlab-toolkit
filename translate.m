%% Translate
% Gordon Bean, March 2012
% Translate gene names, etc using tab delim files.

function trans = translate( filename, refs, refcol, targetcol, blank )

    %% Open file
    fid = fopen( filename );
    if (fid == 0)
        error('Unable to open file: %s');
    end
    tmp = textscan(fid, ...
        [repmat('%s ', [1 max(refcol, targetcol)]) '%*[^\n]']);
    fclose(fid);
    
    %% Translate
    trans = refs;
    tmpi = achar( refs, tmp{refcol}, 1);
    trans(~isnan(tmpi)) = tmp{targetcol}(notnan(tmpi));

    if (nargin > 4)
        trans(isnan(tmpi)) = {blank};
    end
end