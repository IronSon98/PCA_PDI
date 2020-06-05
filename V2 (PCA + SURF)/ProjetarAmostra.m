%Projeta uma nova amostra no espa�o vetorial P 
%Entrada:
%   bag_features = amostra a ser projetada
%   mn = m�dia de cada coluna da matriz de dados
%   P = dados no novo espa�o vetorial (autofaces no caso de imagens)
%Sa�da:
%   x = amostra no novo espa�o vetorial
function x = ProjetarAmostra(bag_features, mn,P)
    x = bag_features';
    x = double(x) - mn;
    x = P' * x;
end