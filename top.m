%% TOP - returns a binary upper triangular matrix of the size of the input
% Gordon Bean, February 2014
%
% Useful with IN. For example:
% symmetric = apply(rand(10), @(x) x + x');
% hist(in(symmetric,@top), 20);

function t = top(x)
    t = triu(true(size(x)),1);
end