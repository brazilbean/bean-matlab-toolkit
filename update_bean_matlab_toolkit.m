%% UPDATE BEAN MATLAB TOOLKIT
% Gordon Bean, February 2014
%
% Syntax
% update_bean_matlab_toolkit();
% update_bean_matlab_toolkit('Name', Value, ...);
%
% Description
% update_bean_matlab_toolkit() downloads the zipped Bean Matlab Toolkit 
% repository from github.com and extracts the files to the current location
% of the toolkit (or a specified location).
%
% update_bean_matlab_toolkit('Name', Value, ...) accepts
% name-value parameters from the following list:
%  'path' - a string specifying the path to install the toolkit. If not
%  provided, update_bean_matlab_toolkit will determine the
%  current location of the toolkit and overwrite your current copy. 
%
%  'url' - a string specifying the URL of the ZIP file to be downloaded.
%  You probably won't change this.
%
%  'verbose {true} - if false, the progress messages will not be displayed.
%

function update_bean_matlab_toolkit( varargin )
    params = default_param( varargin, ...
        'path', '', ...
        'url', ['https://github.com/brazilbean/' ...
            'bean-matlab-toolkit/archive/master.zip'], ...
        'verbose', true);
    
    % Determine the location of the toolkit
    if isempty(params.path)
        foo = which('update_bean_matlab_toolkit');

        tmp = textscan(foo, '%s', 'delimiter', '/');
        params.path = sprintf('%s/', tmp{1}{1:end-2});
    end
    verbose(params.verbose, ...
        'The toolkit will be installed in %s\n', params.path);
    
    % Download .ZIP file
    verbose(params.verbose, 'Downloading the ZIP archive...\n');
    zipfile = urlwrite(params.url, '/tmp/mcat.zip/');
    
    % Extract files
    verbose(params.verbose, 'Extracting the ZIP contents...\n');
    unzip( zipfile, params.path );
    
    % Add MCAT to path
    addpath([params.path 'bean-matlab-toolkit-master/']);
    addpath([params.path 'bean-matlab-toolkit-master/imageproc/']);
    rehash

    verbose(params.verbose, 'Installation complete.\n\n');
end