%Projeta uma nova amostra no espaço vetorial P 
%Entrada:
%   bag_features = amostra a ser projetada
%   mn = média de cada coluna da matriz de dados
%   P = dados no novo espaço vetorial (autofaces no caso de imagens)
%Saída:
%   x = amostra no novo espaço vetorial
function x = ProjetarAmostra(bag_features, mn,P)
    x = bag_features';
    x = double(x) - mn;
    x = P' * x;
end