function [Err] = ComputeErr(X_n,  X_test_n, Vnorm, Vmean)

Err = norm((X_test_n- X_n) .* Vnorm,'fro')/norm(X_n .* Vnorm + Vmean,'fro');
end