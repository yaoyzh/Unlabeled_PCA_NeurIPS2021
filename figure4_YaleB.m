clear all;
close all;
format compact;

%% parameters setting
load('ID3.mat'); 
X_raw = ID3;
h = 192; 
w = 168; 
person_idx = 3;

r = 4;
k = 16; % number of outliers out of 64 points
v_patches = 12;
h_patches = 7;

[m,n] = size(X_raw);
f_id = 0;
outlier_ratio = k/n;
shuffled_ids = randperm(n);
outliers_id = shuffled_ids(1:k);
if length(setdiff(outliers_id, [1]))==k
    outliers_id(1) = 1;
end
if length(setdiff(outliers_id, [23]))==k
    outliers_id(2) = 23;
end

shuffled_method = 'outlier';
%% shuffle the patches
% perm_pattern = 0 for fully shuffling; 1 for partially shuffling.
perm_flag = 1;
[X_tilde] = permute_face(X_raw, outliers_id, h, w, v_patches, h_patches, perm_flag);

%% UPCA pipeline
% parameters for DPCP
c = n-r;
budget = 10000;
epsilon_J = 1e-9;
mu_min = 1e-15;
maxIter = 1000;
delta = 1e-9;

[B_IRLS, t_IRLS] = DPCP_IRLS_proj(X_tilde,c,delta,maxIter,epsilon_J,budget);
t_IRLS

for j = [1,23]

img_title = 'raw';
image_face(X_raw(:, j), f_id, h, w, img_title);
f_id = f_id + 1;

y = X_tilde(:, j);
img_title = shuffled_method;
image_face(y, f_id, h, w, img_title);
f_id = f_id + 1;


B_solved = B_IRLS; PCAmethod = 'DPCP-IRLS';
tic
c_hat = AIEM(B_solved,y); 
time_aiem = toc
LRWCmethod ='-AIEM';
Xj_solved = B_solved* c_hat;
img_title = [PCAmethod LRWCmethod];
image_face(Xj_solved, f_id, h, w, img_title);
f_id = f_id + 1;

tic;
c_hat = L1_RR_proximal(B_solved,y); 
time_l1 = toc
LRWCmethod ='-L1';
Xj_solved = B_solved* c_hat;
img_title = [PCAmethod LRWCmethod];
image_face(Xj_solved, f_id, h, w, img_title);
f_id = f_id + 1;

tic;
c_hat = PL(B_solved,y); 
time_pl = toc
LRWCmethod ='-PL';
Xj_solved = B_solved* c_hat;
img_title = [PCAmethod LRWCmethod];
image_face(Xj_solved, f_id, h, w, img_title);
f_id = f_id + 1;

tic;
c_hat = LSR(B_solved,y); 
time_lsr = toc
LRWCmethod ='-LSRF';
Xj_solved = B_solved* c_hat;
img_title = [PCAmethod LRWCmethod];
image_face(Xj_solved, f_id, h, w, img_title);
f_id = f_id + 1;

end


