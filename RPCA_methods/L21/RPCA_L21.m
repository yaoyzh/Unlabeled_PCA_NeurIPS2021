% See the paper
% H. Xu, C. Caramanis, and S. Sanghavi. Robust pca via outlier pursuit.
% IEEE Transactions on Information Theory, 58(5):3047–3064, 2012
function [B_sub, tL21] = RPCA_L21(Y,tau,lambda,budget,r)

tstart = tic;
[L, E,iter] = rpca(Y, 'L21', tau, lambda,budget);

[U,~,~] = svd(L);
B_sub = U(:, 1:r);

tL21 = toc(tstart);
end



