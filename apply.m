%% Apply - Pass these values to this function
% Gordon Bean, August 2013
%
% Usage:
% apply(..., function_handle) where ... are the arguments to the function
% handle.
%
% Example:
% apply(3, 4, @(x,y) x + y)

function out = apply(varargin)
    if nargin < 1
        error('apply requires at least 1 input argument');
    end
    out = varargin{end}(varargin{1:end-1});
end