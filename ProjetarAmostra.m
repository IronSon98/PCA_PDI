%Projeta uma nova amostra no espa�o vetorial P
%Entrada:
%   x = amostra a ser projetada
%   mn = m�dia de cada coluna da matriz de dados
%   P = dados no novo espa�o vetorial (autofaces no caso de imagens)
%Sa�da:
%   x = amostra no novo espa�o vetorial
function x = ProjetarAmostra(x,mn,P)
    x = imresize(x, [320 240]);
    x = reshape(x,[size(x,1)*size(x,2),1]);
    %x = extractLBPFeatures(x, 'CellSize', [32 32], 'Normalization', 'L2');
    x = double(x) - mn;
    x = P' * x;
end