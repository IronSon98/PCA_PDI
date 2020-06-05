%Projeta uma nova amostra no espa�o vetorial P
%Entrada:
%   x = amostra a ser projetada
%   mn = m�dia de cada coluna da matriz de dados
%   P = dados no novo espa�o vetorial (autofaces no caso de imagens)
%Sa�da:
%   x = amostra no novo espa�o vetorial
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