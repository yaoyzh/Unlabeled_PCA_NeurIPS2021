% plot the figure 2 in UPCA

f1 = figure;

p1 = plot(inlier_num_set, err_em, '-o', 'LineWidth', 2.5);
hold on;
p2 = plot(inlier_num_set, err_ccv, '-x', 'LineWidth', 2.5);
hold on;
p3 = plot(inlier_num_set, err_gt_em, '--', 'LineWidth', 2.5);
hold on;
p4 = plot(inlier_num_set, err_gt_ccv, '--', 'LineWidth', 2.5);
hold on; 
p5 = plot(inlier_num_set, [1.34; err_gt_ccv(2:4); 0.002], '.w', 'LineWidth', 1e-4,'Marker', 'none');
xticks([inlier_num_set]);
p1.Color = '#D95319';
p2.Color = '#0072BD';
p3.Color = '#D95319';
p4.Color = '#0072BD';
p5.Color = '#0072BD';
set(gca,'Ydir','Normal', 'FontSize', 12, 'Fontname','times new Roman', 'yscale', 'log', 'XDir','reverse'); 
yticks([1e-2, 1e-1, 1e0]);
yticklabels([1e-2, 1e-1, 1e0]);
xlabel('outlier ratio');
xticklabels({'94%', '90%', '85%', '80%', '75%'});
title(['rank = ', num2str(r)])
lgd = legend('AIEM($\hat{S}$)','CCV-Min($\hat{S}$)','AIEM($S^*$)','CCV-Min($S^*$)', ...
    'interpreter', 'Latex', 'Location', 'Northwest')
f1.Units = 'centimeters';
f1.Position = [2 10 6.7 6];
