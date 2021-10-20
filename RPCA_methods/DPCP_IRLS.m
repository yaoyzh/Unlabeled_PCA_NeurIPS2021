% See the paper:
% M. C. Tsakiris and R. Vidal. Dual principal component pursuit. The Journal of Machine Learning Research, 2018
function [B_sub,t_elapsed,k] = DPCP_IRLS(X_tilde,c,delta,T,epsilon_J,budget)

% solves min_B ||X^T B||_1 s.t. B^T B=I
% INPUT
% X_tilde  : DxN data matrix of N data points of dimension D
% c        : Dimension of the orthogonal complement of the subspace.
%            To fit a hyperplane use c=1.
% delta    : Avoids division by zero. Typically is set to 10^(-9).
% T        : Maximal number of iterations. Typically set to 100.
% epsilon_J: Convergence accuracy: Typically set to 10^(-6).
% OUTPUT
% distances: Distance of each point to the estimated subspace.
% B        : Dxc matrix containing in its columns an orthonormal basis for
%            the orthogonal complement of the subspace.

t_start = tic;
[D, N] = size(X_tilde);
Delta_J = Inf;
k = 0;
w = ones(1, N);
J_old = inf(1, N);
J_new = zeros(1, N);

while (Delta_J>epsilon_J) && (k<T) && toc(t_start) <= budget
    dw = sparse(1:N, 1:N, w);
    R_X = X_tilde * dw * X_tilde';
    [U, ~, ~] = svd(R_X);
    B = U(:,D-c+1:D);
    J_new = sqrt(vecnorm(B'*X_tilde, 2, 1));
    w = 1./max(J_new.^3, delta);
    k = k + 1;
    Delta_J = 1-sum(J_new)/(sum(J_old)+10^(-9));
    J_old = J_new;
end

t_elapsed = toc(t_start);
[U,~,~] = svd(B);
B_sub = U(:, c+1:end);

end

