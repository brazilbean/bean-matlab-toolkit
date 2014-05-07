%% ANGLECOSINE - computes the cosine of the angle between vectors
% Gordon Bean, May 2014
%
% Syntax
% cosine = anglecosine( X );
% cosine = anglecosine( X, [], W );
% cosine = anglecosine( X, Y );
% cosine = anglecosine( X, Y, W );
% cosine = anglecosine( X, Y Wx, Wy );
%
% Description
% anglecosine computes the cosine of the angle between vectors. If the
% inputs are matrices, it computes the cosine of the angle between each
% pair of column vectors (all pairs of the same matrix if only one matrix
% is input, or all pairs of columns between matrices if X and Y are input).
%
% Weights may be provided to perform a weighted meausurement. To provide
% weights for a single matrix input (X), pass an empty matrix as Y. W
% should be a matrix of the same size as its corresponding variable. 
%
% The cosine of the angle is computed as the dot product of the vectors
% divided by the product of vector norms.

function cosine = anglecosine(X, Y, Wx, Wy)
    y_was_empty = nargin < 2 || isempty(Y);
    if y_was_empty
        % Y not provided or is empty
        Y = X;
    end
    if nargin < 3
        Wx = ones(size(X));
    end
    if nargin < 4
        if y_was_empty
            Wy = Wx;
        else
            Wy = ones(size(Y));
        end
    end
    
    % Ignore nans
    Wx(isnan(X)) = 0;
    Wy(isnan(Y)) = 0;
    X(isnan(X)) = 0;
    Y(isnan(Y)) = 0;
    
    % Dot product divided by norms
    xmag = sqrt((X.^2 .* Wx)' * Wy);
    ymag = sqrt(Wx' * (Y.^2 .* Wy));
    cosine = ((X.*Wx)' * (Y.*Wy)) ./ (xmag .* ymag);
end