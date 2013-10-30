%% Deriv - compute the derivative of a polynomial
% Gordon Bean, October 2013
%
% Accepts a polynomial as returned by polyfit and returns a polynomial of
% the same form. Assumes the polynomial coefficients are listed in the
% first dimension.

function pd = deriv( pp )
    pw = (size(pp,1)-1 : -1 : 1)';
    pd = bsxfun(@times, pw, pp(1:end-1,:));
end