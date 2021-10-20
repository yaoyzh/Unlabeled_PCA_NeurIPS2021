% See the paper: 
% M. Slawski, E. Ben-David, "Linear Regression with Sparsely Permuted Data", 
% Electronic Journal of Statistics, 2019.
function x_hat = L1_RR(A,y)

[m, n] = size(A);
lambda = 0.01*sqrt(log(n)/n);

cvx_expert true
cvx_begin quiet
    variables x_hat(n,1) e(m,1);
%     minimize(norm(y-A*x_hat,1));
    minimize(power(2, norm(y-A*x_hat-sqrt(n)*e, 2)/n)+lambda*norm(e,1));
cvx_end
 
end