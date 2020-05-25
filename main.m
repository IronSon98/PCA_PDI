%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%      Trabalho lista     %%
%%          MAIN           %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all, close all
teste = 0.3;
treino = 0.7;
cellsize = [44 44];

% caminho = 'C:\Users\pedri\OneDrive\Área de Trabalho\Semestre atual\PDI\Lista 6\PCA_PDI\Dataset\Faces\'; %ATENÇÃO ALTERAR ESSE CAMINHO NO ARQUIVO lerImgs TAMBEM
caminho = 'C:\Users\pedri\OneDrive\Área de Trabalho\Semestre atual\PDI\Lista 6\PCA_PDI\Dataset\Emocoes\'; %ATENÇÃO ALTERAR ESSE CAMINHO NO ARQUIVO lerImgs TAMBEM

imds = imageDatastore(caminho,'IncludeSubfolders',true,'LabelSource','foldernames');
[trainCell, testCell] = splitEachLabel(imds, treino, teste);

n_class = 7; % total de classes
n_train = size(trainCell.Files,1); % Numero de n_trains
n_test = size(testCell.Files,1); %  Numero de Teste
n_amostras = (n_train /n_class) + (n_test /n_class); %total de amostras
train = n_train /n_class;%  Numero de Traino por classes 
test = n_test /n_class;%  Numero de teste por classes 
data = lerImgs(trainCell ,n_train);
data = data';
 cd('C:\Users\pedri\OneDrive\Área de Trabalho\Semestre atual\PDI\Lista 6\PCA_PDI\') % COLOQUE O ENDEREÇO !!!!

[P PC mn] = GerarPCs(data);

hit = 0;
hit_class(:,n_class) = 0;

for i=1:n_test
   
        x = readimage(testCell, i);
        x = imcrop(x, [75 ,80, 111, 149]);    
%         imshow(x);
%         featureHog = extractHOGFeatures(x, 'CellSize',cellsize);
        featureHog = extractHOGFeatures(x);
        featureHog = featureHog';
        
        d = Classificar(PC, ProjetarAmostra(featureHog,mn,P));
                            
        if trainCell.Labels(d) == testCell.Labels(i)
            pos_class = ceil(d/train);
            hit_class(pos_class) = hit_class(pos_class) + 1;
            hit = hit + 1;
            
            d_hit = d;
            test_hit = i;
        else
            d_error = d;
            test_error = i;
        end
end
%% mostrar imagens de acerto && acerto
img_hit = readimage(trainCell, d_hit);
img_test_hit = readimage(testCell, test_hit);
figure; imshowpair(img_hit, img_test_hit, 'montage');

img_error = readimage(trainCell, d_error);
img_test_error = readimage(testCell, test_error);
figure; imshowpair(img_error, img_test_error, 'montage');
%% mostrar acertos por classe e acertos acertos totais 
for i = 1:n_class
    
               acuracy_class(i) = (hit_class(i)/test)*100;
               disp(strcat('Hits per class - ',32,int2str(i),...
               ': hitsperclass:',...
               ' - ',32,num2str(acuracy_class(i)), '%. '));
end
               
            hitpercent = (hit/n_test) * 100;
            misspercent = 100 - hitpercent;

            disp(strcat('Porcentagem de erro =',32, num2str(misspercent), '%'));
            disp(strcat('Porcentagem de acerto =',32, num2str(hitpercent), '%'));
            disp('\\\');

