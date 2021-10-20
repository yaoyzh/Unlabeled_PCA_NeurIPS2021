clear all;
close all;
format compact;
%% PARAMETER SETTING
% X_gt: ground truth data matrix
% m: #rows, n: #columns, r: rank(X_gt)
m = 50;
n = 500;
rank_set = 1:1:49;
outlier_ratio_set = 0.1:0.1:0.9;
noise_level = 0; 
num_trials = 1; % run how many trials to take average
num_rank = length(rank_set);
num_or = length(outlier_ratio_set);

ldeg_random_CoP = zeros(num_rank, num_or, num_trials);
ldeg_random_IRLS = zeros(num_rank, num_or, num_trials);
ldeg_random_L21 = zeros(num_rank, num_or, num_trials);
ldeg_random_seo = zeros(num_rank, num_or, num_trials);

ldeg_CoP = zeros(num_rank, num_or, num_trials);
ldeg_IRLS = zeros(num_rank, num_or, num_trials);
ldeg_L21 = zeros(num_rank, num_or, num_trials);
ldeg_seo = zeros(num_rank, num_or, num_trials);

ldeg2_CoP = zeros(num_rank, num_or, num_trials);
ldeg2_IRLS = zeros(num_rank, num_or, num_trials);
ldeg2_L21 = zeros(num_rank, num_or, num_trials);
ldeg2_seo = zeros(num_rank, num_or, num_trials);

ldeg3_CoP = zeros(num_rank, num_or, num_trials);
ldeg3_IRLS = zeros(num_rank, num_or, num_trials);
ldeg3_L21 = zeros(num_rank, num_or, num_trials);
ldeg3_seo = zeros(num_rank, num_or, num_trials);

ldeg4_CoP = zeros(num_rank, num_or, num_trials);
ldeg4_IRLS = zeros(num_rank, num_or, num_trials);
ldeg4_L21 = zeros(num_rank, num_or, num_trials);
ldeg4_seo = zeros(num_rank, num_or, num_trials);

%% Loops

% noisy data generation
for t_idx = 1:num_trials
    for r_idx = 1:num_rank
        r = rank_set(r_idx)
        [X_gt, X_gt_unnorm, U_gt, C_gt] = generate_gt_data(m, n, r);
        % here X_noisy is the ground-truth data because noise_level=0
        X_noisy = X_gt;
        for or_index = 1:num_or
            outlier_ratio = outlier_ratio_set(or_index);
            % Shuffle the first n_prime columns to generate the observed data
            % X_tilde_random: random outliers
            % X_tilde: alpha=1, outliers are permuted vectors
            % X_tilde2: alpha=0.6
            % X_tilde3: alpha=0.2
            % X_tilde4: alpha=0.1
            [X_tilde, X_tilde2, X_tilde3, X_tilde4, X_tilde_random, idOutliers_gt] = ...
                generate_observed_data_group(X_noisy, 1, outlier_ratio);
            %% Run the first stage
            % parameters for DPCP
            c = m-r; % for DPCP
            budget = 10000;
            epsilon_J = 1e-9;
            maxIter = 1000;
            delta = 1e-9;
            % parameters for SEO
            lambda_seo = 0.95;
            alpha_seo = 10;
            T_seo = 1000;
            % parameters for L21-RPCA (OP)
            tau = 1;
            lambda_l21 = 0.5;
            
            [B_random_IRLS, t_random_IRLS] = DPCP_IRLS(X_tilde_random, c, delta, maxIter,epsilon_J,budget);
            [B_random_seo, t_random_seo] =  SEO(X_tilde_random,lambda_seo,alpha_seo, T_seo, r);
            [B_random_CoP, t_random_CoP] = CoP(X_tilde_random, r);
            [B_random_L21, t_random_L21] = RPCA_L21(X_tilde_random, tau,lambda_l21,budget, r);
            
            [B_IRLS, t_IRLS] = DPCP_IRLS(X_tilde, c, delta, maxIter,epsilon_J,budget);
            [B_seo, t_seo] =  SEO(X_tilde,lambda_seo,alpha_seo, T_seo, r);
            [B_CoP, t_CoP] = CoP(X_tilde, r);
            [B_L21, t_L21] = RPCA_L21(X_tilde, tau,lambda_l21,budget, r);
            
            [B2_IRLS, t2_IRLS] = DPCP_IRLS(X_tilde2, c, delta, maxIter,epsilon_J,budget);
            [B2_seo, t2_seo] =  SEO(X_tilde2,lambda_seo,alpha_seo, T_seo, r);
            [B2_CoP, t2_CoP] = CoP(X_tilde2, r);
            [B2_L21, t2_L21] = RPCA_L21(X_tilde2, tau,lambda_l21,budget, r);
            
            [B3_IRLS, t3_IRLS] = DPCP_IRLS(X_tilde3, c, delta, maxIter,epsilon_J,budget);
            [B3_seo, t3_seo] =  SEO(X_tilde3,lambda_seo,alpha_seo, T_seo, r);
            [B3_CoP, t3_CoP] = CoP(X_tilde3, r);
            [B3_L21, t3_L21] = RPCA_L21(X_tilde3, tau,lambda_l21,budget, r);
            
            [B4_IRLS, t4_IRLS] = DPCP_IRLS(X_tilde4, c, delta, maxIter,epsilon_J,budget);
            [B4_seo, t4_seo] = SEO(X_tilde4,lambda_seo,alpha_seo, T_seo, r);
            [B4_CoP, t4_CoP] = CoP(X_tilde4, r);
            [B4_L21, t4_L21] = RPCA_L21(X_tilde4, tau,lambda_l21,budget, r);
            
            %% compute the degree of the largest principal angle between the ground-truth and the estimate 
            ldeg_random_IRLS(r_idx, or_index, t_idx) = SubspaceAffinity(B_random_IRLS, U_gt);
            ldeg_random_CoP(r_idx, or_index, t_idx) = SubspaceAffinity(B_random_CoP, U_gt);
            ldeg_random_seo(r_idx, or_index, t_idx) = SubspaceAffinity(B_random_seo, U_gt);
            ldeg_random_L21(r_idx, or_index, t_idx) = SubspaceAffinity(B_random_L21, U_gt);
            
            ldeg_IRLS(r_idx, or_index, t_idx) = SubspaceAffinity(B_IRLS, U_gt);
            ldeg_CoP(r_idx, or_index, t_idx) = SubspaceAffinity(B_CoP, U_gt);
            ldeg_seo(r_idx, or_index, t_idx) = SubspaceAffinity(B_seo, U_gt);
            ldeg_L21(r_idx, or_index, t_idx) = SubspaceAffinity(B_L21, U_gt);
            
            ldeg2_IRLS(r_idx, or_index, t_idx) = SubspaceAffinity(B2_IRLS, U_gt);
            ldeg2_CoP(r_idx, or_index, t_idx) = SubspaceAffinity(B2_CoP, U_gt);
            ldeg2_seo(r_idx, or_index, t_idx) = SubspaceAffinity(B2_seo, U_gt);
            ldeg2_L21(r_idx, or_index, t_idx) = SubspaceAffinity(B2_L21, U_gt);
            
            ldeg3_IRLS(r_idx, or_index, t_idx) = SubspaceAffinity(B3_IRLS, U_gt);
            ldeg3_CoP(r_idx, or_index, t_idx) = SubspaceAffinity(B3_CoP, U_gt);
            ldeg3_seo(r_idx, or_index, t_idx) = SubspaceAffinity(B3_seo, U_gt);
            ldeg3_L21(r_idx, or_index, t_idx) = SubspaceAffinity(B3_L21, U_gt);
            
            ldeg4_IRLS(r_idx, or_index, t_idx) = SubspaceAffinity(B4_IRLS, U_gt);
            ldeg4_CoP(r_idx, or_index, t_idx) = SubspaceAffinity(B4_CoP, U_gt);
            ldeg4_seo(r_idx, or_index, t_idx) = SubspaceAffinity(B4_seo, U_gt);
            ldeg4_L21(r_idx, or_index, t_idx) = SubspaceAffinity(B4_L21, U_gt);
            
        end
    end
end

ldeg_mean_random_IRLS = mean(ldeg_random_IRLS, 3);
ldeg_mean_random_seo = mean(ldeg_random_seo, 3);
ldeg_mean_random_L21 = mean(ldeg_random_L21, 3);
ldeg_mean_random_CoP = mean(ldeg_random_CoP, 3);

ldeg_mean_IRLS = mean(ldeg_IRLS, 3);
ldeg_mean_seo = mean(ldeg_seo, 3);
ldeg_mean_L21 = mean(ldeg_L21, 3);
ldeg_mean_CoP = mean(ldeg_CoP, 3);

ldeg_mean2_IRLS = mean(ldeg2_IRLS, 3);
ldeg_mean2_seo = mean(ldeg2_seo, 3);
ldeg_mean2_L21 = mean(ldeg2_L21, 3);
ldeg_mean2_CoP = mean(ldeg2_CoP, 3);

ldeg_mean3_IRLS = mean(ldeg3_IRLS, 3);
ldeg_mean3_seo = mean(ldeg3_seo, 3);
ldeg_mean3_L21 = mean(ldeg3_L21, 3);
ldeg_mean3_CoP = mean(ldeg3_CoP, 3);

ldeg_mean4_IRLS = mean(ldeg4_IRLS, 3);
ldeg_mean4_seo = mean(ldeg4_seo, 3);
ldeg_mean4_L21 = mean(ldeg4_L21, 3);
ldeg_mean4_CoP = mean(ldeg4_CoP, 3);

run 'plot_figure1.m';
