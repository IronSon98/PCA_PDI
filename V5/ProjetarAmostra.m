%Projeta uma nova amostra no espa�o vetorial P
%Entrada:
%   x = amostra a ser projetada
%   mn = m�dia de cada coluna da matriz de dados
%   P = dados no novo espa�o vetorial (autofaces no caso de imagens)
%Sa�da:
%   x = amostra no novo espa�o vetorial
function features = ProjetarAmostra(x,mn,P)
    %img_test = imresize(x, [640 480]);
    %img_test = reshape(img_test,[size(img_test,1)*size(img_test,2),1]);
    %LBP = extractLBPFeatures(img_test, 'NumNeighbors', 4, 'Radius', 1, 'Upright', false, 'Interpolation', 'Nearest', 'CellSize', [4 4], 'Normalization', 'L2');
    %features = reshape(features, [size(features,1)*size(features,2), 1]);
    features = double(x) - mn;
    features = P' * features;
end