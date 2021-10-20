function X_solved = US_mat(X_tilde, B_in, O_id, name_method, perm_flag)

X_solved = X_tilde;
method = str2func(name_method);
if perm_flag == 1
    for j = O_id
        y = X_tilde(:, j);
        [c_hat] = method(B_in, y);
        xj = B_in * c_hat;
        xj = perm_from_sort(X_tilde(:, j), xj);
        X_solved(:, j) = xj;
    end
else
    for j = O_id
        y = X_tilde(:, j);
        [c_hat] = method(B_in, y);
        xj = B_in * c_hat;
        X_solved(:, j) = xj;
    end
end

end