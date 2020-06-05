%Projeta uma nova amostra no espaço vetorial P
%Entrada:
%   x = amostra a ser projetada
%   mn = média de cada coluna da matriz de dados
%   P = dados no novo espaço vetorial (autofaces no caso de imagens)
%Saída:
%   x = amostra no novo espaço vetorial
function z = ProjetarAmostra(x,mn,P, CellSize)
    y = reshape(x,[size(x,1)*size(x,2),1]);
    y = single(y);
    y = y';
    featureHOG = extractHOGFeatures(x, 'CellSize', CellSize);
    z = [y , featureHOG];
    z = z';
    z = double(z) - mn;
    z = P' * z;
end