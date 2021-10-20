function [X_gt, X_gt_unnorm, U_gt, C_gt, A] = generate_gt_data(m, n, r)
% This function generate a normalized noisy data matrix X_noisy

A = randn(m, r);
[U_full, ~, ~] = svd(A);
U_gt = U_full(:, 1:r);
C_gt = (1/sqrt(r)) * randn(r, n);
X_gt_unnorm = U_gt *  C_gt;
X_gt = X_gt_unnorm ./ vecnorm(X_gt_unnorm);

end