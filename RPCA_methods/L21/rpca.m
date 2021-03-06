function [L, E,iter] = rpca(X, method, tau, lambda,budget)
% RPCA performs robust PCA by convex optimization.
% 
%     A = lrmc(X, tau, W)
% 
% performs robust PCA by convex optimization:
%   min ||L||_* + \lambda ||E||_1 s.t. X = L + E     or
%   min ||L||_* + \lambda ||E||_{2,1} s.t. X = L + E
% Parameters
% X: D by N data matrix.
% tau: Parameter of the augmented Lagrangian.
% method: ??L1?? for gross errors or ??L21?? for outliers
% Returned values
% L: Low-rank completion of the matrix X.
% E: Matrix of errors.

[D, N] = size(X);
thr = 1e-8;
maxIter = 10000;
% Initialization
E = zeros(size(X));
Y = zeros(size(X));
% Iterations
iter = 0;
tend = 0;
tstart = tic;
while(tend <= budget)
    % Update L
    L = svs(X - E + (1/tau) * Y, 1/tau);
    % Update E
    A = X - L + Y / tau;
    if strcmp(method, 'L1')
        E = max( abs(A) - lambda/tau, 0 ) .* sign(A);
    elseif strcmp(method, 'L21')
        normA = sqrt( sum(A .^2, 1) );
        temp = max( normA - lambda/tau, 0) ./ normA;
        [~, nC] = size(temp);
        for jj = 1:nC
            E(:,jj) = A(:,jj) .* temp(jj); % dynamically pre-allocate
        end
    end
    % Update Y
    Y = Y + tau * (X - L - E);
    % Check convergence
    error = max(max(abs(X - L - E)));
%     fprintf('Iteration %d, error is %f\n', iter, error);  
    if error < thr || iter > maxIter
        break;
    end
    iter = iter + 1;
    tend = toc(tstart);
end
%fprintf('Iteration %d, error is %f\n', iter, error);
end

function A = svs(X, thr)
% Singula Value Shrinkage
    [U, S, V] = svd(X, 'econ');
    S = S - thr;
    S(S<0) = 0;
    A = U * S * V';
end
