%--------------------------------------------------------------------------
% D: The given data matrix

% n: The number of data points sampled by CoP algorithm as basis for the recovered subspace

% r: The rank of low rank component. Here it is assumed that the required rank is given. 
% If it is not given, the rank can be estimated using the data points with high coherence values. 

% U: The obtained basis for the recovered subspace

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

function [B_sub,t_CoP] = CoP(D, r) 
tic;
r = fix(r);

[N1,N] = size(D) ; 

T = repmat(sum(D.^2).^0.5 , N1 , 1) ;
X = D./T ; 

G = X'*X ; G = G - diag(diag(G)) ;
p = sum(G.^2) ; p = p/max(p) ; 

[~, sorted_idx] = sort(p, 'descend');

X_in = D(:, sorted_idx(1:r));
[U, ~, ~] = svd(X_in);
B_sub = U(:, 1:r);

t_CoP = toc;


