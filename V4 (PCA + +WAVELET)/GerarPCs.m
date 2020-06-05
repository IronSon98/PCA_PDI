%Gera a matriz de componentes principais
%Entrada:
%   data = matriz de dados. Cada amostra de medições é representada em uma coluna
%saída:
%   P = dados no novo espaço vetorial (autofaces no caso de imagens)
%   PC = matriz componentes principais
%   mn = média de cada coluna da matriz de dados

function [P, PC, mn] = GerarPCs(data)
    [M, N] = size(data);
    mn = mean(data,2); %calcular a média
    data = double(data) - repmat(mn,1,N); %imagens - media

    covariancia = data' * data; %matriz de covariância
    [PC,V] = eig(covariancia); %autovetores e autovalores

    V = diag(V); 

    clear covariancia, clear M, clear N;

    %ordenar autovetores e autovalores

    [junk,rindices] = sort(-1*V);
    V = V(rindices);
    V = diag(V);
    PC = PC(:,rindices);

    clear junk , clear rindices, clear V;

    %cálculo das autofaces

    P = data * PC;
    i = size(PC,2);

    clear PC;

    %projeção das imagens no espaço de faces
    PC = [];
    for j = 1:i
        temp = P' * data(:,j);
        PC = [PC temp];
    end

    clear i, clear j, clear temp;
end