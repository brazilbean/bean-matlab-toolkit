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
    out = varargin{end}(varargin{1:end-1});
end