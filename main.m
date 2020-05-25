%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%      Trabalho lista     %%
%%          MAIN           %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all, close all

ind=7; %qtd de individuos
amostras = 20; %qtd de amostras por foto
treino= 12; %qtd de amostras para treino
acertos = 1;
erros = 1;
cel = 4;

% nome_classe = ["KA", "KL", "KM", "KR", "MK", "NA", "NM", "TM", "UY", "YM"];
nome_classe = ["AN", "DI", "FE", "HA", "NE", "SA", "SU"];

caminho = 'C:\Users\pedri\OneDrive\Área de Trabalho\Semestre atual\PDI\Lista 6\PCA_PDI\Dataset\Emocoes\'; %ATENÇÃO ALTERAR ESSE CAMINHO NO ARQUIVO lerImgs TAMBEM
data = lerImgs(nome_classe, ind, treino);

 cd('C:\Users\pedri\OneDrive\Área de Trabalho\Semestre atual\PDI\Lista 6\PCA_PDI\') % COLOQUE O ENDEREÇO !!!!

[P PC mn] = GerarPCs(data);

teste = amostras-treino;
k = 0;
acertoInd = [];
acertoFoto = [];
erroInd = [];
erroFoto = [];
featureHog = [];
aux = 1;
aux2 = 1;
hit = 0;

for i=1:ind
    hitsperclass = 0;
    for j=treino+1:amostras
        
        x = imread(strcat(caminho, nome_classe(i),'\', nome_classe(i), num2str(j),'.tiff'));
        x = imcrop(x, [75 ,80, 111, 149]);    
        featureHog = extractHOGFeatures(x);
        featureHog = featureHog';

        d = Classificar(PC, ProjetarAmostra(featureHog,mn,P));
                            
                    if (ceil(d/treino) == i)
                        hit = hit + 1;
                        hitsperclass = hitsperclass + 1;
                    end
               end
               
               disp(strcat('Hits per class - ',int2str(i),...
                   ': hitsperclass: ',int2str(hitsperclass),...
                   ' - ',num2str(100*hitsperclass/(amostras - treino)), '%. ',...
                   ' .total:',int2str(amostras - treino)));
            end

            hitpercent = hit / (ind * (amostras - treino));
            misspercent = 1 - hitpercent;

            totalt = num2str(ind * (amostras - treino));

            disp(strcat('numero de testes=', totalt))
            disp(strcat('numero de acertos=', int2str(hit)));

            disp(strcat('Porcentagem de erro=', num2str(100 * misspercent), '%'));
            disp(strcat('Porcentagem de acerto=', num2str(100 * hitpercent), '%'));
            disp('\\\');


