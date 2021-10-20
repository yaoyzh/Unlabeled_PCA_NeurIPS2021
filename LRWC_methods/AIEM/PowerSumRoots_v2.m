function X = PowerSumRoots_v2(A, y, K)
% computes the roots of the first K power-sum polynomials for the 
% shuffled linear regression problem (A,y)

[m,n] = size(A);

% create symbolic polynomial variables
sym_x = polysym('x',[n,1]);

% construct the equations of degree k=1,..,K in n variables
equations = cell(K,1);

for k = 1 : K
    % construct all monomials of degree k in n variables
    e = exponent(k,n).';
    sym_x_copies = sym_x * ones(1,nchoosek(k+n-1,n-1));
    monomials_k = prod(sym_x_copies .^ e,1);  
    
    % construct coefficients of k-th equation
    V = sum(veronese(A',k,1),2);
  
    y_k = sum(y.^k);
    equations(k) = cellstr(monomials_k*V-y_k);
end

poly_system = BertiniLab('variable_group',sym_x,'function_def',equations);
poly_system.Bertini_io_folder = './Bertini-IO';

poly_system = poly_system.solve;
sols = poly_system.match_solutions('raw_solutions'); % 0.04 s

X = real(double(sols.x));
X = unique(X.', 'rows').';
BertiniClean

end