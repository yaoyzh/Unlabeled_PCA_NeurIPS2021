function [X_tilde, perm_pattern, idOutliers] = generate_observed_data(X_noisy, shuffled_ratio, outlier_ratio)
% This function generate the observed data corrupted by unknown
% permutations on some columns. 
%   perm_pattern: column j of this matrix records the permutation pattern of column j
%   X_tilde: X_gt with corruption

[m, n] = size(X_noisy);
num_shuffled = fix(shuffled_ratio * m); 
num_outliers = fix(outlier_ratio * n); % # permuted columns
X_tilde = X_noisy;
perm_pattern = ones(m, num_outliers);
for j = 1: num_outliers
    rp = randperm(m);
    shuffled_index = rp(1:num_shuffled);
    shuffled_how = randperm(num_shuffled);
    shuffled_pattern= shuffled_index(shuffled_how);
    perm = 1:1:m;
    perm(shuffled_index) = shuffled_pattern;
    while sum(abs(perm-(1:1:m))) < 0.1
        rp = randperm(m);
        shuffled_index = rp(1:num_shuffled);
        shuffled_how = randperm(num_shuffled);
        shuffled_pattern= shuffled_index(shuffled_how);
        perm = 1:1:m;
        perm(shuffled_index) = shuffled_pattern;
    end
    perm_pattern(:, j) = perm;
    X_tilde(:, j) = X_noisy(perm_pattern(:, j), j);
end
idOutliers_binary = [ones(1, num_outliers), zeros(1, n - num_outliers)]; % n-dimensional logical vector to indicate outliers
idOutliers = find(idOutliers_binary .* (1:1:n));

end