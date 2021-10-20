% Implementation of the algorithm in the following paper:
% M. C.Tsakiris, L. Peng, A. Conca, L. Kneip, Y. Shi, and H. Choi, 
% "An algebraic-geometric approach to linear regression without correspondences", 
% in IEEE Transactions on Information Theory, 2020.
function [x_hat, mle_e] = SLR_hardEM_v2(A,y,x_init, n_iter)
% for solving the Shuffled Linear Regression (SLR) problem (A,y).

% OUTPUT
% x: n x 1 solution to the SLR problem
% Pi: corresponding permutation that matches rows of A to y (applied on A)

% initializations
%[m, n] = size(A);
%[~, I] = size(x_init);

% Identity = eye(m);

% sort y in ascending order
[y, idx] = sort(y,1);

tt = 1;
x_hat = x_init;
J = inf;
while (tt <= n_iter)

    y_hat = A * x_hat;

    [y_hat, Pi_I] = sort(y_hat, 1);
    A = A(Pi_I,:);

    mle_e = norm(y - y_hat);

    if J - mle_e < 1e-4
        break;
    end

    if mle_e < J
        J = mle_e;
    end
    x_hat = A \ y;
    tt = tt+1;
end

end
