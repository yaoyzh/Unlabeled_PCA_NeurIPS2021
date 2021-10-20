function [X_solved_em, X_solved_ccv, time_em, time_ccv] = denseSLRsolver2(idOutliers, X_tilde, U_solved)

tic
X_solved_em = X_tilde;

for j = idOutliers
    y = X_tilde(:, j);
    [c_hat_em] = AIEM(U_solved, y);
    X_solved_em(:, j) = U_solved * c_hat_em;
end
time_em = toc;

tic
X_solved_ccv = X_tilde;
for j = idOutliers
    y = X_tilde(:, j);
    [c_hat, ~, ~] = SLR_cvx_max_v4(U_solved, y);
    X_solved_ccv(:, j) = U_solved * c_hat;
end
time_ccv = toc;