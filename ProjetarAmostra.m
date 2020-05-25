%Projeta uma nova amostra no espaço vetorial P
%Entrada:
%   x = amostra a ser projetada
%   mn = média de cada coluna da matriz de dados
%   P = dados no novo espaço vetorial (autofaces no caso de imagens)
%Saída:
%   x = amostra no novo espaço vetorial
function x = ProjetarAmostra(x,mn,P)
    x = double(x) - mn;
    x = P' * x;
end