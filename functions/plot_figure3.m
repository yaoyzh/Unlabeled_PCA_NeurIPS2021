% plot figure 3 in UPCA
close all;
 
f1 = figure
f1s1 =imagesc(shuffled_ratio_set, r_set, err_ratio_psd_mean', [0,0.3]);
set(gca,'Ydir','Normal', 'FontSize', 12, 'Fontname','times new Roman'); 
c = flipud(gray);colormap(c);
yticks([1:6:25]); 
yticklabels([1:6:25]);
xticks(0.1:0.1:0.6)
xticklabels({'.1', '.2', '.3', '.4', '.5', '.6'});  
xlabel('\alpha');
ylabel('r  ','Rotation', 0);
title('PSD')

f2 = figure
imagesc(shuffled_ratio_set,r_set,  err_ratio_gt_psd_mean', [0,0.3]);
c = flipud(gray); 
colormap(c);
set(gca,'Ydir','Normal', 'FontSize', 12, 'Fontname','times new Roman');
xticks(0.1:0.1:0.6)
xticklabels({'.1', '.2', '.3', '.4', '.5', '.6'});   
yticks([1:6:25]); 
% xticks(0.1:0.1:0.6)
yticklabels([1:6:25]); 
xlabel('\alpha');
ylabel('r  ','Rotation', 0);
title('PSD-GT')

f3 = figure
imagesc(shuffled_ratio_set, r_set,  err_ratio_rg_mean', [0,0.3]);
c = flipud(gray); 
colormap(c);
set(gca,'Ydir','Normal', 'FontSize', 12, 'Fontname','times new Roman');
yticks([1:6:25]); 
% xticks(0.1:0.1:0.6)
yticklabels([1:6:25]); 
xticks(0.1:0.1:0.6)
xticklabels({'.1', '.2', '.3', '.4', '.5', '.6'}); 
xlabel('\alpha');
ylabel('r  ','Rotation', 0);
title('L1-RR')

f4 = figure
imagesc(shuffled_ratio_set, r_set,  err_ratio_gt_rg_mean', [0,0.3]);
c = flipud(gray); 
colormap(c);
set(gca,'Ydir','Normal', 'FontSize', 12, 'Fontname','times new Roman');
yticks([1:6:25]); 
% xticks(0.1:0.1:0.6)
yticklabels([1:6:25]); 
xticks(0.1:0.1:0.6)
xticklabels({'.1', '.2', '.3', '.4', '.5', '.6'});   
xlabel('\alpha');
ylabel('r  ','Rotation', 0);
title('L1-RR-GT')

f5 = figure
imagesc(shuffled_ratio_set, r_set,  err_ratio_lsr_mean', [0,0.3]);
c = flipud(gray); 
colormap(c);
set(gca,'Ydir','Normal', 'FontSize', 12, 'Fontname','times new Roman');
yticks([1:6:25]); 
% xticks(0.1:0.1:0.6)
yticklabels([1:6:25]); 
xticks(0.1:0.1:0.6)
xticklabels({'.1', '.2', '.3', '.4', '.5', '.6'}); 
xlabel('\alpha');
ylabel('r  ','Rotation', 0);
title('LSRF')

f6 = figure
imagesc(shuffled_ratio_set, r_set,  err_ratio_gt_lsr_mean', [0,0.3]);
c = flipud(gray); 
colormap(c);
set(gca,'Ydir','Normal', 'FontSize', 12, 'Fontname','times new Roman');
yticks([1:6:25]); 
% xticks(0.1:0.1:0.6)
yticklabels([1:6:25]); 
xticks(0.1:0.1:0.6)
xticklabels({'.1', '.2', '.3', '.4', '.5', '.6'});   
xlabel('\alpha');
ylabel('r  ','Rotation', 0);
title('LSRF-GT')


f7 = figure
imagesc(shuffled_ratio_set, r_set, ldegree1_IRLS_mean', [0,2]);
c = flipud(gray); 
colormap(c);
set(gca,'Ydir','Normal', 'FontSize', 12, 'Fontname','times new Roman');
yticklabels([1:6:25]); yticks([1:6:25]); 
xticks(0.1:0.1:0.6)
xticklabels({'.1', '.2', '.3', '.4', '.5', '.6'});  
xlabel('\alpha');
ylabel('r  ','Rotation', 0);
title('degree-DPCP-IRLS')

cbd = colorbar;cbd.Location = 'westoutside';
cbd.TickLabels = {'$0^\circ$','$1^\circ$', '$2^\circ$'};
cbd.TickLabelInterpreter = 'latex';


f8 = figure;
c = flipud(gray);
caxis([0,0.3]);
set(gca, 'FontSize', 12, 'Fontname','times new Roman');
colormap(c); cb = colorbar; cb.Location = 'westoutside';
yticklabels([]);
xlabel('\alpha');
title('colorbar')

f1.Units = 'centimeters';
f2.Units = 'centimeters';
f3.Units = 'centimeters';
f4.Units = 'centimeters';

f1.Position = [5 2 4.5 4.5];
f2.Position = [10 2 4.5 4.5];
f3.Position = [15 2 4.5 4.5];
f4.Position = [20 2 4.5 4.5];

f5.Units = 'centimeters';
f6.Units = 'centimeters';
f5.Position = [25 2 4.5 4.5];
f6.Position = [30 2 4.5 4.5];
f7.Units = 'centimeters';
f7.Position = [35 2 4.5 4.5];
f8.Units = 'centimeters';
f8.Position = [1 2 4.5 4.5];

