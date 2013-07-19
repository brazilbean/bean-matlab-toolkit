%% Slidefun - execute a function on a sliding window in a vector
% Gordon Bean, May 2013
%
% FUN must be a function handle that operates on columns of a matrix.
% By default, edges of the vector are padded with NaNs.

function out = slidefun( data, win, fun, varargin )
    params = default_param( varargin, ...
        'includeCenter', true, ...
        'padFunction', @nan, ...
        'positions', 1 : numel(data));

    % Define neighbor indices
    if ~islogical(win)
        % Treat as length of window
        win = true(1,win);
    end
    
    wi = (1 : length(win)) - fix(length(win)/2);
    ni = in(wi(win));
    
    if ~params.includecenter
        ni = in(setdiff(ni, 0))';
    end
    
    % Reshape to columns
    cols = params.padfunction(length(ni), numel(data));
    ii = bsxfun(@plus, params.positions, ni);
    iival = ii > 0 & ii <= numel(data);
    
    cols(iival) = data(ii(iival));
    
    % Execute function and reshape output
    out = params.padfunction(size(data));
    out(params.positions) = fun(cols);

end