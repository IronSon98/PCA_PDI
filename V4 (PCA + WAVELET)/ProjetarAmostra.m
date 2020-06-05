%Projeta uma nova amostra no espaço vetorial P
%Entrada:
%   x = amostra a ser projetada
%   mn = média de cada coluna da matriz de dados
%   P = dados no novo espaço vetorial (autofaces no caso de imagens)
%Saída:
%   x = amostra no novo espaço vetorial
function features = ProjetarAmostra(x,mn,P,sn)
    img_test = imresize(x, [320 240]);
    Feature1 = featureMatrix(sn, img_test);
    Feature1 = mean(mean(Feature1,2),3);
    %img_test = reshape(img_test,[size(img_test,1)*size(img_test,2),1]);
%     LBP = extractLBPFeatures(img_test, 'Upright' , false);
    %features = reshape(features, [size(features,1)*size(features,2), 1]);
    features = double(Feature1) - mn;
    features = P' * features;
end