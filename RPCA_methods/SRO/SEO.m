% See the paper:
% C. You, D. P. Robinson, and R. Vidal. 
% Provable self-representation based outlier detection in a union of subspaces. 
% In IEEE Conference on Computer Vision and Pattern Recognition, 2017.
function [B, timecost] = SEO(Y,lambda,alpha, T, r)

% R-graph outlier detection
tic;
N = size(Y,2);
% step 1: compute representation R from Y (line 1 of Alg. 1)
% lambda = 0.95;
% alpha = 10;
gamma = @(X, y, lambda, alpha)  alpha*lambda/max(abs(X'*y));
EN_solver =  @(X, y) rfss( full(X), full(y), lambda / gamma(X, y, lambda, alpha), (1-lambda) / gamma(X, y, lambda, alpha) );
R = selfRepresentation(cnormalize(Y), EN_solver);
% step 2: compute transition P from R (line 2 of Alg. 1)
P = cnormalize(abs(R), 1)';
% step 3: compute \pi from P (line 3 - 7 of Alg. 1)
% T = 1000;
pi = ones(1, N) / N;
pi_bar = zeros(1, N);
for ii = 1:T
    pi = pi * P;
    pi_bar = pi_bar + pi;
end
pi_bar = pi_bar / T;
%
feat = pi_bar; % larger values in feat indicate higher "inlierness"
[~, sorted_idx] = sort(feat, 'descend');

X_in = Y(:, sorted_idx(1:r));
[U, ~, ~] = svd(X_in);
B = U(:, 1:r);
timecost = toc;

end