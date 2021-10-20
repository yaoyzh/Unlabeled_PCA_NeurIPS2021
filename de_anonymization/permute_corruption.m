function [X_tilde] = permute_corruption(X, id_out, shuffled_ratio)

m = size(X,1);
n = size(X,2);
ni = fix(n/3);
X_tilde = X;
num_shuffled = fix(shuffled_ratio * m);
for j = id_out
    rp = randperm(m);
    shuffled_index = rp(1:num_shuffled);
    shuffled_how = randperm(num_shuffled);
    shuffled_pattern= shuffled_index(shuffled_how);
    perm = 1:1:m;
    perm(shuffled_index) = shuffled_pattern;
    X_tilde(:, j) = X(perm, j);
end
% 
% rp = randperm(m);
%     shuffled_index = rp(1:num_shuffled);
%     shuffled_how = randperm(num_shuffled);
%     shuffled_pattern= shuffled_index(shuffled_how);
%     perm1 = 1:1:m;
%     perm1(shuffled_index) = shuffled_pattern;
%     X_tilde(:, ni+1:2*ni) = X(perm1, ni+1:2*ni);
% rp = randperm(m);
%     shuffled_index = rp(1:num_shuffled);
%     shuffled_how = randperm(num_shuffled);
%     shuffled_pattern= shuffled_index(shuffled_how);
%     perm2 = 1:1:m;
%     perm2(shuffled_index) = shuffled_pattern;
%     X_tilde(:, 2*ni+1:3*ni) = X(perm2, 2*ni+1:3*ni);

end