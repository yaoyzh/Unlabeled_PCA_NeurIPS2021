clear all;
close all;
format compact;
%% PARAMETER SETTING
% X_gt: ground truth data matrix
% m: #rows, n: #columns, r: rank(X_gt)
m = 50;
n = 100;
r = 3;
shuffled_ratio = 1; % alpha=1
inlier_num_set = [6, 10:5:25];

noise_level = 0.01;
num_trials = 1;
num_ir = length(inlier_num_set);

degree1_IRLS = zeros(num_ir, num_trials);
timecost_em = zeros(num_ir, num_trials);
timecost_ccv = zeros(num_ir, num_trials);
timecost_gt_ccv = zeros(num_ir, num_trials);
timecost_gt_em = zeros(num_ir, num_trials);
err_ratio_gt_ccv = zeros(num_ir, num_trials);
err_ratio_gt_em = zeros(num_ir, num_trials);
err_ratio_ccv = zeros(num_ir, num_trials);
err_ratio_em = zeros(num_ir, num_trials);


%% Loops
for t_idx = 1:num_trials
    [X_gt, X_gt_unnorm, U_gt, C_gt] = generate_gt_data(m, n, r);
    noise = randn(m, n);
    noise = noise_level * (noise ./ vecnorm(noise));
    X_noisy = X_gt + noise;
    X_noisy = X_noisy ./ vecnorm(X_noisy);  % noisy data generation
    
    for in_index = 1:num_ir
        inlier_num = inlier_num_set(in_index);
        outlier_num = n - inlier_num;
        
        [X_tilde, ~, ~] = generate_observed_data_number(X_noisy, shuffled_ratio, outlier_num);
        
        % parameters for DPCP-IRLS
        c = m-r; % for DPCP
        budget = 10000;
        epsilon_J = 1e-9;
        mu_min = 1e-15;
        maxIter = 1000;
        delta = 1e-9;
        
        [B_IRLS, t_IRLS, ~] = DPCP_IRLS(X_tilde, c, delta, maxIter, epsilon_J, budget);
        degree1_IRLS(in_index,t_idx) = SubspaceAffinity(B_IRLS, U_gt);
        [X_solved_em, X_solved_ccv,  timecost_em(in_index,t_idx),  timecost_ccv(in_index,t_idx)] = ...
            denseSLRsolver2(1:n, X_tilde, B_IRLS);
        
        [X_solved_gt_em, X_solved_gt_ccv, timecost_gt_em(in_index,t_idx),  timecost_gt_ccv(in_index,t_idx)] = ...
            denseSLRsolver2(1:n, X_tilde, U_gt);
        
        %% Evaluate the Refined results
        
        err_ratio_ccv(in_index, t_idx) =  EvaluateRefined(X_solved_ccv, X_gt, U_gt)
        err_ratio_em(in_index, t_idx) =  EvaluateRefined(X_solved_em, X_gt, U_gt)
        
        err_ratio_gt_ccv(in_index, t_idx) = EvaluateRefined(X_solved_gt_ccv, X_gt, U_gt)
        err_ratio_gt_em(in_index, t_idx) = EvaluateRefined(X_solved_gt_em, X_gt, U_gt)
    end
end

err_ccv = mean(err_ratio_ccv, 2);
err_em = mean(err_ratio_em, 2);
err_gt_ccv = mean(err_ratio_gt_ccv, 2);
err_gt_em = mean(err_ratio_gt_em, 2);

run 'plot_figure2';
