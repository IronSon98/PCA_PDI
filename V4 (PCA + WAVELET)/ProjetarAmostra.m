%Projeta uma nova amostra no espaço vetorial P
%Entrada:
%   x = amostra a ser projetada
%   mn = média de cada coluna da matriz de dados
%   P = dados no novo espaço vetorial (autofaces no caso de imagens)
%Saída:
%   x = amostra no novo espaço vetorial
function features = ProjetarAmostra(x,mn,P,sn)
%     img_test = imresize(x, [320 240]);
    Feature1 = featureMatrix(sn, img_test,'Transform','log');
    Feature1 = mean(mean(Feature1,2),3);
    features = double(Feature1) - mn;
    features = P' * features;
end