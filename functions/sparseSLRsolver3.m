function [X_solved_rg, X_solved_psd, X_solved_lsr, timecost_rg, timecost_psd, timecost_lsr] = ...
    sparseSLRsolver3(idOutliers, X_tilde, U_solved)

tic
X_solved_rg = X_tilde;
for j = idOutliers
    y = X_tilde(:, j);
    c_hat = L1_RR(U_solved, y);
    X_solved_rg(:, j) = U_solved * c_hat;
end
timecost_rg = toc;

tic
X_solved_psd = X_tilde;
for j = idOutliers
    y = X_tilde(:, j);
    [c_hat] = PL(U_solved, y);
    X_solved_psd(:, j) = U_solved * c_hat;
end
timecost_psd = toc;

tic
X_solved_lsr = X_tilde;
for j = idOutliers
    y = X_tilde(:, j);
    [c_hat] = LSR(U_solved, y);
    X_solved_lsr(:, j) = U_solved * c_hat;
end
timecost_lsr = toc;


end