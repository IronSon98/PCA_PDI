str_load = '70-30';
load(strcat('workspace_surf_', str_load, '.mat'));
x_70 = hits_accuracy;

str_load = '60-40';
load(strcat('workspace_surf_', str_load, '.mat'));
x_60 = hits_accuracy;
 
str_load = '50-50';
load(strcat('workspace_surf_', str_load, '.mat'));
x_50 = hits_accuracy;
 
data = [x_70' x_60' x_50'];
x = figure; graph_accuracy = stem(data); 
xlim([1 51]); ylim([0 101]);
xlabel('Iteração'); ylabel('Acurácia %');
lgd = legend({'196/84', '168/112', '140/140'}, 'Location','southeast');
lgd.Title.String = 'Treino/Teste Qtd. de Imagens';
title('Variação das Acurácias - PCA + Bag of Features');

saveas(x, 'graphic_comparison_BAG.jpeg');


