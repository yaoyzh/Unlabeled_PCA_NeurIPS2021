color1 = '#0F7002';
color2 = '#513ED8';
color5 = '#0000AE';
color4 = '#800000';
color6 = '#be002f';
color3 = '#ca6924';

sl = length(shuffled_ratio_list);
s_id = 1: sl;
fg = figure;
errorbar( mean_PL, std_PL,'Color',color3,'LineWidth',1.3);hold on;
errorbar( mean_L1, std_L1,'Color',color1,'LineWidth',1.3);hold on;
errorbar( mean_LSR, std_LSR,'Color',color6,'LineWidth',1.3);hold on;
errorbar(mean_tilde, std_tilde,'k--', 'LineWidth',1.5);hold on;
xlim([1,10]);xticklabels({ '', '0.2', '', '0.4', '','0.6', '', '0.8', '', '1.0'});
lgd = legend('PL [30]','$\ell_{1}$-RR [28]',  'Algorithm 2', '$\tilde{X}$',  ...
    'interpreter', 'Latex', 'Location', 'NorthEastOutside')
lgd.NumColumns = 1;
legend('boxoff')
set(gca,'Ydir','Normal', 'FontSize', 14, 'Fontname','times new Roman');
xlabel('\alpha','FontSize', 18);

fg.Units = 'centimeters';
fg.Position = [5 5 10 8];

