function [x_AIEM] = AIEM(A,y)

% Albebraically Initialized Expectation Maximization (AIEM)
% for the Shuffled Linear Regression (SLR) problem (A,y)

% INPUT
% A: m x n coefficient matrix
% y: m x 1 permuted observations
% T: maximum iterations of the hardEM algorithm
% epsilon: termination precision of the EM algorithm
% verbose: output additional information for debugging purpose if verbose is true.

% OUTPUT
% x: solution to the SLR problem
% Pi: corresponding permutation matching the rows of A to y (applied on A)

% dimension
[~,n] = size(A);
T = 1e3;
% compute the real part of the roots of the first n power sum polynomials p_k
if n == 3
    X_AI = sympol3Mat(A, y).';
elseif n == 4
    X_AI = sympol4Mat(A, y).';
else
    X_AI = PowerSumRoots_v2(A,y,n);
end

es = vecnorm(sort(y) - sort(A*X_AI, 1), 2, 1);
[~, idx] = min(es);
x_AI = squeeze(X_AI(:, idx));

x_AIEM = SLR_hardEM_v2(A,y,x_AI, T);
end
