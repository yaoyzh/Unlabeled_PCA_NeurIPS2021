clear all;format('compact');

%% Data Loading
load('breast_benign.mat');
data_raw = benign;
perm_flag = 0;

%% Data Inspection
Vmean = mean(data_raw);
data_central = data_raw - Vmean;
Vnorm = vecnorm(data_central);
X = data_central./Vnorm;

m = size(data_raw,1);
n = size(data_raw,2);
id_out = [2:2:n];
id_in = setdiff(1:n, id_out);

r = 4;
O_id = 1:n;
shuffled_ratio_list = 0.1:0.1:1;
trials = 10;
LRWC_name_list = {'LSR','PL','L1_RR_proximal'};

ll = length(LRWC_name_list);
for t_id = 1:trials
    % data corruption
    X_tilde = zeros(m,n,length(shuffled_ratio_list));
    for shuffled_ratio = shuffled_ratio_list
        s_id = fix(shuffled_ratio*10);
        [X_tilde(:,:,s_id)] = permute_corruption(X, id_out, shuffled_ratio);
        [Err_tilde(s_id,t_id)] = ComputeErr(X,  X_tilde(:,:,s_id), Vnorm, Vmean);
    end
    %% UPCA
    for l_id = 1:ll
        LRWC_name = LRWC_name_list{l_id};
            for shuffled_ratio = shuffled_ratio_list
                s_id = fix(shuffled_ratio*10);
                X_tilde_mat = X_tilde(:,:,s_id);
                % parameters for DPCP
                c = m-r;
                budget = 1000;
                epsilon_J = 1e-9;
                maxIter = 10000;
                delta = 1e-9;
                [B_IRLS] = DPCP_IRLS(X_tilde_mat, c, delta, maxIter,epsilon_J,budget);
                X_hat = US_mat(X_tilde_mat, B_IRLS, O_id, LRWC_name, perm_flag);  
                [Err3(s_id,t_id,l_id)] = ComputeErr(X,  X_hat, Vnorm, Vmean);
            end
    end
end

Err_LSR = Err3(:,:, 1)';
mean_LSR = mean(Err_LSR);
std_LSR = std(Err_LSR);
Err_PL = Err3(:,:, 2)';
mean_PL = mean(Err_PL);
std_PL = std(Err_PL);
Err_L1 = Err3(:,:, 3)';
mean_L1 = mean(Err_L1);
std_L1 = std(Err_L1);
mean_tilde = mean(Err_tilde');
std_tilde = std(Err_tilde');

run plotErr.m
