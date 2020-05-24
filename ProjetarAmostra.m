%Projeta uma nova amostra no espaço vetorial P
%Entrada:
%   x = amostra a ser projetada
%   mn = média de cada coluna da matriz de dados
%   P = dados no novo espaço vetorial (autofaces no caso de imagens)
%Saída:
%   x = amostra no novo espaço vetorial
function x = ProjetarAmostra(x,mn,P)
    x = imcrop(x, [75 ,80, 110, 150]);
    points = detectSURFFeatures(x);
    p = points.selectStrongest(20);
    [features, valid_points] = extractFeatures(x, p);
    features = (features - min(features))/(max(features) - min(features));
    x = reshape(features,[size(features,1)*size(features,2),1]);
    x = double(x) - mn;
    x = P' * x;
end