function [err_ratio] = EvaluateRefined(X_solved, X_gt, U_gt)

r = min(size(U_gt, 2), size(X_gt,2));
[U_refine, ~, ~] = svd(X_solved, 'econ');
B_refine = U_refine(:, 1:r);
P_refine = B_refine * B_refine';

D = P_refine * X_solved; X_solved_refine = D ./ vecnorm(D);

err_refine = norm(X_solved_refine - X_gt, 'fro');
err_ratio = err_refine / norm(X_gt, 'fro');

end
