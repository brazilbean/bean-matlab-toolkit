%% polyv - evaluate the polynomial
% Gordon Bean, October 2013
% 
% Like polyval, but computes on matrixes of polynomials instead of just
% vectors.
%
% PP should be K x N, where K is the order of the polynomial and N is the
% number of polynomials to be evaluated. 
%
% X should be M x 1, where M is the number of points at which the
% polynomials will be evaluated. 
%
% MU should be a two-element vector with the mean and standard deviation of
% the domain (X) as returned by polyfit. 

function v = polyv(pp, x, mu)
    if nargin < 3
        mu = [0 1];
    end
    pw = (size(pp,1)-1 : -1 : 0);
    xx = (x - mu(1))./mu(2);
    v = bsxfun(@power, xx, pw) * pp;
end