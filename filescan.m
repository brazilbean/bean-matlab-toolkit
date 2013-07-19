%% File scan
% Gordon Bean, March 2012

function data = filescan( filename, format, varargin )

    %% Open file
    fid = fopen( filename );
    if (fid < 1)
        error('Unable to open file: %s', filename);
    end
    
    %% Scan
    [data pos] = textscan( fid, format, varargin{:} );
    
    %% Check for success
    fseek(fid, 0, 1);
    if (pos ~= ftell(fid))
        error('Failed to load complete file - %s:%i\n', ...
            filename, length(data{1})+1);
    end
    
    %% Close filehandle
    fclose(fid);

end