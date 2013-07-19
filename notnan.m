%% notnan - returns the non-nan elements of an array or matrix
% Gordon Bean, February 2011
% 
% Usage
% notnan( data )

function out = notnan (data)

    out = in(data,~isnan(data));

end