% proximal subgradient implementation of L1-RR using the toolbox of 
% A. Beck and N. Guttmann-Beck.  
% Fom – a matlab toolbox of first-order methods for solving convex optimization problems. Optimization Methods and Software, 2019
function [x_hat] = L1_RR_proximal(A, y)
    [~,n] = size(A);

    par.real_valued_flag = true; par.eco_flag = false; par.print_flag = false;
    par.max_iter = 1e5; par.eps = 1e-6;

    x_hat =  prox_subgradient(@(x)norm(A*x-y, 1), @(x)A'*sign(A*x-y), @(x)0, @(x, a)x, 1, zeros(n,1), par);
end
