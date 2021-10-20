clear all;
close all;
format compact;
%% PARAMETER SETTING
% X_gt: ground truth data matrix
% m: #rows, n: #columns, r: rank(X_gt)
m = 50;
n = 500;
r_set = 1:1:25;
shuffled_ratio_set = 0.1:0.1:0.6; 
outlier_ratio = 0.9;
noise_level = 0.01;
num_trials = 1;
num_sr = length(shuffled_ratio_set);
num_rank = length(r_set);

ldegree1_IRLS = zeros(num_sr, num_rank, num_trials);
timecost_psd = zeros(num_sr, num_rank, num_trials);
timecost_rg = zeros(num_sr, num_rank, num_trials);
timecost_lsr = zeros(num_sr, num_rank, num_trials);
timecost_gt_psd = zeros(num_sr, num_rank, num_trials);
timecost_gt_rg = zeros(num_sr, num_rank, num_trials);
timecost_gt_lsr = zeros(num_sr, num_rank, num_trials);
err_ratio_gt_lsr = zeros(num_sr, num_rank, num_trials);
err_ratio_gt_psd = zeros(num_sr, num_rank, num_trials);
err_ratio_gt_rg = zeros(num_sr, num_rank, num_trials);
err_ratio_psd = zeros(num_sr, num_rank, num_trials);
err_ratio_rg = zeros(num_sr, num_rank, num_trials);
err_ratio_lsr = zeros(num_sr, num_rank, num_trials);

%% Loops2

for t_idx = 1:num_trials
    for r_index = 1:num_rank
        r = r_set(r_index)
        [X_gt, X_gt_unnorm, U_gt, C_gt] = generate_gt_data(m, n, r);
        noise = randn(m, n);
        noise = noise_level * noise ./ vecnorm(noise);
        X_noisy = X_gt + noise;
        X_noisy = X_noisy ./ vecnorm(X_noisy);
        for sr_index = 1:num_sr
            shuffled_ratio = shuffled_ratio_set(sr_index)
            [X_tilde, ~, idOutliers_gt] = generate_observed_data(X_noisy, shuffled_ratio, outlier_ratio);
            
            % parameters for DPCP
            c = m-r; % for DPCP
            budget = 10000;
            epsilon_J = 1e-9;
            mu_min = 1e-15;
            maxIter = 1000;
            delta = 1e-9;
            
            % Shuffle the first n_prime columns to generate the observed data
            [B_IRLS, t_IRLS] = DPCP_IRLS(X_tilde, c, delta, maxIter, epsilon_J, budget);
            ldegree1_IRLS(sr_index, r_index, t_idx) = SubspaceAffinity(B_IRLS, U_gt);
            
            [X_solved_rg, X_solved_psd, X_solved_lsr,  timecost_rg(sr_index, r_index, t_idx), ...
                timecost_psd(sr_index, r_index, t_idx), timecost_lsr(sr_index, r_index, t_idx)] = ...
                sparseSLRsolver3(1:n, X_tilde, B_IRLS);
            [X_solved_gt_rg, X_solved_gt_psd, X_solved_gt_lsr, timecost_gt_rg(sr_index, r_index, t_idx), ...
                timecost_gt_psd(sr_index, r_index, t_idx), timecost_gt_lsr(sr_index, r_index, t_idx)] = ...
                sparseSLRsolver3(1:n, X_tilde, U_gt);
            
            %% Evaluate the refined results
            [err_ratio_gt_psd(sr_index, r_index, t_idx)] = EvaluateRefined(X_solved_gt_psd, X_gt, U_gt)
            [err_ratio_gt_rg(sr_index, r_index, t_idx)] = EvaluateRefined(X_solved_gt_rg, X_gt, U_gt)
            [err_ratio_gt_lsr(sr_index, r_index, t_idx)] = EvaluateRefined(X_solved_gt_lsr, X_gt, U_gt)
            
            [err_ratio_psd(sr_index, r_index, t_idx)] = EvaluateRefined(X_solved_psd, X_gt, U_gt)
            [err_ratio_rg(sr_index, r_index, t_idx)] = EvaluateRefined(X_solved_rg, X_gt, U_gt)
            [err_ratio_lsr(sr_index, r_index, t_idx)] = EvaluateRefined(X_solved_lsr, X_gt, U_gt)
        end
    end
end
err_ratio_psd_mean = mean(err_ratio_psd, 3);
err_ratio_gt_psd_mean = mean(err_ratio_gt_psd, 3);
err_ratio_rg_mean = mean(err_ratio_rg, 3);
err_ratio_gt_rg_mean = mean(err_ratio_gt_rg, 3);
err_ratio_lsr_mean = mean(err_ratio_lsr, 3);
err_ratio_gt_lsr_mean = mean(err_ratio_gt_lsr, 3);
ldegree1_IRLS_mean = mean(ldegree1_IRLS, 3);

run 'plot_figure3.m';