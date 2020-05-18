%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Arlindo Galvão - PDI2019 %%
%%        MAIN             %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all, close all

ind=7; %qtd de individuos
amostras=20; %qtd de amostras por foto
treino=15; %qtd de amostras para treino
acertos = 1;
erros = 1;

% RT_3: Rocha
% RT_7: Folhas
% RT_8: Tijolos
% RT_19: Madeira
% RT_21: Capim
% RT_22: Piso
% RT_24: Tapete

%nome_classe = ["RT3_", "RT7_", "RT8_", "RT19_", "RT21_", "RT22_","RT24_"];
%nome_classe = ["KA", "KL", "KM", "KR", "MK", "NA", "NM", "TM", "UY", "YM"];
nome_classe = ["AN", "DI", "FE", "HA", "NE", "SA", "SU"];

%caminho = 'F:\Backup\Desktop\Faculdade\9º Período\Visão Computacional - OP\PCA\dataset_ground_att\'; %ATENÇÃO ALTERAR ESSE CAMINHO NO ARQUIVO lerImgs TAMBEM
caminho = 'F:\Backup\Desktop\Faculdade\9º Período\Visão Computacional - OP\PCA\Dataset_Japas\Dataset\Emocoes\'; %ATENÇÃO ALTERAR ESSE CAMINHO NO ARQUIVO lerImgs TAMBEM

data = lerImgs(nome_classe, ind, treino);
%data = lerDados;

 cd('F:\Backup\Desktop\Faculdade\9º Período\Visão Computacional - OP\PCA\') % COLOQUE O ENDEREÇO !!!!

[P PC mn] = GerarPCs(data);

teste = amostras-treino;
%teste = 5;
k = 0;
acertoInd = [];
acertoFoto = [];
erroInd = [];
erroFoto = [];
aux = 1;
aux2 = 1;


for i=1:ind
    for j=treino+1:amostras
        
        %x = imread(strcat(caminho, nome_classe(i),'\', nome_classe(i), num2str(j),'.jpg'));
        x = imread(strcat(caminho, nome_classe(i),'\', nome_classe(i), num2str(j),'.tiff'));
        %x = load(strcat(caminho,'s',num2str(i),'\','dado_',(int2str(j))));
        
        d = Classificar(PC, ProjetarAmostra(x,mn,P));
        %d = Classificar(PC, ProjetarAmostra(x.dados,mn,P));
        d = d/treino;
        id = ceil(d);
        if id == i
           k = k+1;
           if aux <= acertos
               acertoInd(aux) = i;
               acertoFoto(aux) = j;
               aux = aux+1;
           end
        else
            if aux2 <= erros
               erroInd(aux2) = i;
               erroFoto(aux2) = j;
               aux2 = aux2+1;
            end
        end
        clear im, clear x, clear d
    end
end


perc = (k/(ind*(amostras-treino)))*100;
formatSpec = '\nFotos de teste: %2.2i Fotos de teste reconhecidas: %2.2i \nPercentual de acerto: %2.2f% \n\n';
fprintf(formatSpec,teste*ind,k,perc);

clear formatSpec;


%Codigo para exibir imagens de erro e acerto
i = 1;
while(i <= acertos)   
    
    %x = imread(strcat(caminho, nome_classe(acertoInd(i)),'\', nome_classe(acertoInd(i)), num2str(acertoFoto(i)),'.jpg'));
    x = imread(strcat(caminho, nome_classe(acertoInd(i)),'\', nome_classe(acertoInd(i)), num2str(acertoFoto(i)),'.tiff'));
  
    d = Classificar(PC, ProjetarAmostra(x,mn,P));
    figure;
    imshowpair(reshape(data(:,d),[size(x,1),size(x,2),size(x,3)]),x,'montage');
    
    
    d = d/treino;
    if (d-(floor(d)) == (1/treino))
       fotoReconhecida = 1;
    elseif(d-(floor(d)) == (2/treino))
       fotoReconhecida = 2;
    else
       fotoReconhecida = 3;
    end
   
   formatSpec = '\nIndivíduo: %2.2i Foto de teste: %2.2i Foto Reconhecida: %2.2i% \n\n';
   fprintf(formatSpec,acertoInd(i),acertoFoto(i),fotoReconhecida);
   

   
   clear im, clear x, clear d;
   i = i+1;
   
end
clear formatSpec;
i = 1;
while(i <= erros)
    
    %x = imread(strcat(caminho, nome_classe(erroInd(i)),'\', nome_classe(erroInd(i)), num2str(erroFoto(i)),'.jpg'));
    x = imread(strcat(caminho, nome_classe(erroInd(i)),'\', nome_classe(erroInd(i)), num2str(erroFoto(i)),'.tiff'));
    
    d = Classificar(PC, ProjetarAmostra(x,mn,P));
    figure;
    imshowpair(reshape(data(:,d),[size(x,1),size(x,2),size(x,3)]),x,'montage');
    d = d/treino;
    if(d-(floor(d)) == (1/treino))
       fotoErrada = 1;
    elseif(d-(floor(d)) == (2/treino))
       fotoErrada = 2;
    else
       fotoErrada = 3;
    end
   
    formatSpec = '\nIndivíduo: %2.2i Foto de teste: %2.2i Indivíduo Reconhecido: %2.2i Foto Reconhecida: %2.2i \n\n';
    fprintf(formatSpec,erroInd(i),erroFoto(i),ceil(d),fotoErrada);

    clear im, clear x, clear d;
    i = i+1;
   
end

clear Y projData media s x y;
