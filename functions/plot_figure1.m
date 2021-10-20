% plot figure 1 in UPCA
close all

f2 = figure
imagesc(outlier_ratio_set,rank_set,   abs(ldeg_mean_random_L21), [0, 90]);c = flipud(gray);colormap(c);
set(gca,'Ydir','Normal', 'FontSize', 12, 'Fontname','times new Roman');
yticks(10:10:49);
xticks(0.1:0.1:0.9);
yticklabels([]);
xticklabels([]);
title('OP random')

f3 = figure
imagesc(outlier_ratio_set, rank_set,  abs(ldeg_mean_random_CoP), [0, 90]);c = flipud(gray);colormap(c);
set(gca,'Ydir','Normal', 'FontSize', 12, 'Fontname','times new Roman');
yticks(10:10:49); xticks(0.1:0.1:0.9);
yticklabels([]);
xticklabels([]);
title('CoP random')

f4 = figure
imagesc(outlier_ratio_set, rank_set,  abs(ldeg_mean_random_seo), [0, 90]);c = flipud(gray);colormap(c);
set(gca,'Ydir','Normal', 'FontSize', 12, 'Fontname','times new Roman');
yticks(10:10:49);
xticks(0.1:0.1:0.9);
% yticklabels([10:10:49]);
xticklabels([]);
title('SE random')


f6 = figure
imagesc(outlier_ratio_set,rank_set,   abs(ldeg_mean_L21), [0, 90]);c = flipud(gray);colormap(c);
set(gca,'Ydir','Normal', 'FontSize', 12, 'Fontname','times new Roman');
yticks(10:10:49);%
xticks(0.1:0.1:0.9);
yticklabels([]);
xticklabels([]);
title('OP a=1')

f7 = figure
imagesc(outlier_ratio_set, rank_set,  abs(ldeg_mean_CoP), [0, 90]);c = flipud(gray);colormap(c);
set(gca,'Ydir','Normal', 'FontSize', 12, 'Fontname','times new Roman');
yticks(10:10:49);
xticks(0.1:0.1:0.9);
yticklabels([]);
xticklabels([]);
title('CoP a=1')

f8 = figure
imagesc(outlier_ratio_set, rank_set,  abs(ldeg_mean_seo), [0, 90]);c = flipud(gray);colormap(c);
set(gca,'Ydir','Normal', 'FontSize', 12, 'Fontname','times new Roman');
yticks(10:10:49);
xticks(0.1:0.1:0.9);%yticklabels([10:10:49]);
xticklabels([]);
title('SE a=1')


f10 = figure
imagesc(outlier_ratio_set,rank_set,   abs(ldeg_mean2_L21), [0, 90]);c = flipud(gray);colormap(c);
set(gca,'Ydir','Normal', 'FontSize', 12, 'Fontname','times new Roman');
yticks(10:10:49);
xticks(0.1:0.1:0.9);
yticklabels([]);
xticklabels([]);
title('OP a=0.6')

f11 = figure
imagesc(outlier_ratio_set, rank_set,  abs(ldeg_mean2_CoP), [0, 90]);c = flipud(gray);colormap(c);
set(gca,'Ydir','Normal', 'FontSize', 12, 'Fontname','times new Roman');
yticks(10:10:49);
xticks(0.1:0.1:0.9);
yticklabels([]);
xticklabels([]);
title('CoP a=0.6')

f12 = figure
imagesc(outlier_ratio_set, rank_set,  abs(ldeg_mean2_seo), [0, 90]);c = flipud(gray);colormap(c);
set(gca,'Ydir','Normal', 'FontSize', 12, 'Fontname','times new Roman');
yticks(10:10:49);
xticks(0.1:0.1:0.9);%yticklabels([10:10:49]);
xticklabels([]);
title('SE a=0.6')

f14 = figure
imagesc(outlier_ratio_set,rank_set,   abs(ldeg_mean3_L21), [0, 90]);c = flipud(gray);colormap(c);
set(gca,'Ydir','Normal', 'FontSize', 12, 'Fontname','times new Roman');
yticks(10:10:49);
yticklabels([]);
xticklabels([]);
title('OP a=0.2')


f15 = figure
imagesc(outlier_ratio_set, rank_set,  abs(ldeg_mean3_CoP), [0, 90]);c = flipud(gray);colormap(c);
set(gca,'Ydir','Normal', 'FontSize', 12, 'Fontname','times new Roman');
yticks(10:10:49);
xticks(0.1:0.1:0.9);
yticklabels([]);
xticklabels([]);
title('CoP a=0.2')


f16 = figure
imagesc(outlier_ratio_set, rank_set,  abs(ldeg_mean3_seo), [0, 90]);c = flipud(gray);colormap(c);
set(gca,'Ydir','Normal', 'FontSize', 12, 'Fontname','times new Roman');
yticks(10:10:49);;
xticks(0.1:0.1:0.9);%yticklabels([10:10:49]);
xticklabels([]);
title('SE a=0.2')


f18 = figure
imagesc(outlier_ratio_set,rank_set,   abs(ldeg_mean4_L21), [0, 90]);c = flipud(gray);colormap(c);
set(gca,'Ydir','Normal', 'FontSize', 12, 'Fontname','times new Roman');
yticks(10:10:49);
yticklabels([]);
xticks(0.1:0.1:0.9);
xticklabels({'0.1', ' ', '0.3', ' ', '0.5', ' ', '0.7', ' ', '0.9'});
title('OP a=0.1')

f19 = figure
imagesc(outlier_ratio_set, rank_set,  abs(ldeg_mean4_CoP), [0, 90]);c = flipud(gray);colormap(c);
set(gca,'Ydir','Normal', 'FontSize', 12, 'Fontname','times new Roman');
yticks(10:10:49)
yticklabels([]);
xticks(0.1:0.1:0.9);
xticklabels({'0.1', ' ', '0.3', ' ', '0.5', ' ', '0.7', ' ', '0.9'});
title('CoP a=0.1')

f20 = figure
imagesc(outlier_ratio_set, rank_set,  abs(ldeg_mean4_seo), [0, 90]);c = flipud(gray);colormap(c);
set(gca,'Ydir','Normal', 'FontSize', 12, 'Fontname','times new Roman');
yticks(10:10:49);
xticks(0.1:0.1:0.9);
%yticklabels([]);
xticklabels({'0.1', ' ', '0.3', ' ', '0.5', ' ', '0.7', ' ', '0.9'});
title('SE a=0.1')

f21 = figure
imagesc(outlier_ratio_set, rank_set, abs(ldeg_mean_random_IRLS), [0, 90]);
set(gca,'Ydir','Normal', 'FontSize', 12, 'Fontname','times new Roman'); 
c = flipud(gray);colormap(c);
yticks(10:10:49);
xticks(0.1:0.1:0.9);
xticklabels([]);
yticklabels([]);
title('IRLS random')

f22 = figure
imagesc(outlier_ratio_set, rank_set, abs(ldeg_mean_IRLS), [0, 90]);
set(gca,'Ydir','Normal', 'FontSize', 12, 'Fontname','times new Roman'); 
c = flipud(gray);colormap(c);
yticks(10:10:49);
xticks(0.1:0.1:0.9);
xticklabels([]);
yticklabels([]);
title('IRLS a=1')


f23 = figure
imagesc(outlier_ratio_set, rank_set, abs(ldeg_mean2_IRLS), [0, 90]);
set(gca,'Ydir','Normal', 'FontSize', 12, 'Fontname','times new Roman'); 
c = flipud(gray);colormap(c);
yticks(10:10:49)
xticklabels([]);
yticklabels([]);
title('IRLS a=0.6')


f24 = figure
imagesc(outlier_ratio_set, rank_set, abs(ldeg_mean3_IRLS), [0, 90]);
set(gca,'Ydir','Normal', 'FontSize', 12, 'Fontname','times new Roman'); 
c = flipud(gray);colormap(c);
yticks(10:10:49);
xticks(0.1:0.1:0.9);
xticklabels([]);
yticklabels([]);
title('IRLS a=0.2')


f25 = figure
imagesc(outlier_ratio_set, rank_set, abs(ldeg_mean4_IRLS), [0, 90]);
set(gca,'Ydir','Normal', 'FontSize', 12, 'Fontname','times new Roman'); 
c = flipud(gray);colormap(c);
yticks(10:10:49);
xticks(0.1:0.1:0.9);
yticklabels([]);
xticklabels({'0.1', ' ', '0.3', ' ', '0.5', ' ', '0.7', ' ', '0.9'});
title('IRLS a=0.1')


f2.Units = 'centimeters';
f3.Units = 'centimeters';
f4.Units = 'centimeters';
f6.Units = 'centimeters';
f7.Units = 'centimeters';
f8.Units = 'centimeters';
f10.Units = 'centimeters';
f11.Units = 'centimeters';
f12.Units = 'centimeters';
f14.Units = 'centimeters';
f15.Units = 'centimeters';
f16.Units = 'centimeters';
f18.Units = 'centimeters';
f19.Units = 'centimeters';
f20.Units = 'centimeters';
f21.Units = 'centimeters';
f22.Units = 'centimeters';
f23.Units = 'centimeters';
f24.Units = 'centimeters';
f25.Units = 'centimeters';

f2.Position = [9 30 4 3];
f3.Position = [13 30 4 3];
f4.Position = [17 30 4 3];
f6.Position = [9 27 4 3];
f7.Position = [13 27 4 3];
f8.Position = [17 27 4 3];
f10.Position = [9 24 4 3];
f11.Position = [13 24 4 3];
f12.Position = [17 24 4 3];
f14.Position = [9 21 4 3];
f15.Position = [13 21 4 3];
f16.Position = [17 21 4 3];
f18.Position = [9 18 4 3.3];
f19.Position = [13 18 4 3.3];
f20.Position = [17 18 4 3.3];
f21.Position = [1 30 4 3];
f22.Position = [1 27 4 3];
f23.Position = [1 24 4 3];
f24.Position = [1 21 4 3];
f25.Position = [1 18 4 3.3];
