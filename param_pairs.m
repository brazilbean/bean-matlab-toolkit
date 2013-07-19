%% Param pairs
% Gordon Bean, March 2013

function out = param_pairs( params )

    out = in(cat(2, fieldnames(params), struct2cell(params))');

end