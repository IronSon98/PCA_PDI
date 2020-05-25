%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%      Trabalho lista     %%
%%          MAIN           %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all, close all
treino = 0.7;
n_class = 7; % total de classes
cellsize = [32 32];

% caminho = 'C:\Users\pedri\OneDrive\Área de Trabalho\Semestre atual\PDI\Lista 6\PCA_PDI\Dataset\Faces\'; %ATENÇÃO ALTERAR ESSE CAMINHO NO ARQUIVO lerImgs TAMBEM
caminho = 'C:\Users\pedri\OneDrive\Área de Trabalho\Semestre atual\PDI\Lista 6\PCA_PDI\Dataset\Emocoes\'; %ATENÇÃO ALTERAR ESSE CAMINHO NO ARQUIVO lerImgs TAMBEM

imds = imageDatastore(caminho,'IncludeSubfolders',true,'LabelSource','foldernames');

n_executions = 100;
hitpercent = [];
acuracy_class_media(:,n_class) = 0;

for l = 1:n_executions
[trainCell, testCell] = splitEachLabel(imds, treino, 'randomized');


n_train = size(trainCell.Files,1); % Numero de n_trains
n_test = size(testCell.Files,1); %  Numero de Teste
n_amostras = (n_train /n_class) + (n_test /n_class); %total de amostras
train = n_train /n_class;%  Numero de Traino por classes 
test = n_test /n_class;%  Numero de teste por classes 


data = lerImgs(trainCell ,n_train, cellsize);
data = data';
 cd('C:\Users\pedri\OneDrive\Área de Trabalho\Semestre atual\PDI\Lista 6\PCA_PDI\') % COLOQUE O ENDEREÇO !!!!

[P PC mn] = GerarPCs(data);

hit = 0;
hit_class = [0,0,0,0,0,0,0] ;

for i=1:n_test
   
        x = readimage(testCell, i);
        x = imcrop(x, [75 ,80, 111, 149]);    
        y = reshape(x,[size(x,1)*size(x,2),1]);
        y = double(y);
        y = y';
        featureHog = extractHOGFeatures(x, 'CellSize',cellsize);
%         featureHog = extractHOGFeatures(x);
        featureHog = double(featureHog);
        z = [y , featureHog];
        z = z';
        
        d = Classificar(PC, ProjetarAmostra(z,mn,P));
                            
        if trainCell.Labels(d) == testCell.Labels(i)
            
            %%Para acuracia por classes 
            pos_class = ceil(d/train);
            hit_class(pos_class) = hit_class(pos_class) + 1;
            hit = hit + 1;
            
            
            %% Para mostrar a ultima imagem de acerto
            d_hit = d;
            test_hit = i;
        else
            %% Para mostrar a ultima imagem de error
            d_error = d;
            test_error = i;
        end
end

%% mostrar acertos por classe e acertos acertos totais 
for i = 1:n_class
    
               acuracy_class(i) = (hit_class(i)/test)*100;
               acuracy_class_media(i) = acuracy_class_media(i) + acuracy_class(i);
               disp(strcat('Hits per class - ',32,int2str(i),...
               ': hitsperclass:',...
               ' - ',32,num2str(acuracy_class(i)), '%. '));
end
            
            
            hitpercent(l) = (hit/n_test) * 100;
            misspercent(l) = 100 - hitpercent(l);

            disp(strcat('Porcentagem de erro =',32, num2str(misspercent(l)), '%'));
            disp(strcat('Porcentagem de acerto =',32, num2str(hitpercent(l)), '%'));
            disp('\\\');
end

Sum_hitpercent = 0;
Sum_misspercent = 0;

for i = 1:n_executions
    Sum_hitpercent = Sum_hitpercent +  hitpercent(i);
    Sum_misspercent = Sum_misspercent +  misspercent(i);
end
%%
media_hitpercent = Sum_hitpercent/n_executions;
media_misspercent = Sum_misspercent/n_executions;

for i=1:n_class
    
        media_hit_per_class(i) = (acuracy_class_media(i)/n_executions);
        disp(strcat('Hits per class - ',32,int2str(i),...
        ': hitsperclass media :',...
        ' - ',32,num2str(media_hit_per_class(i)), '%. '));
end
            disp(strcat('Porcentagem de erro em media =',32, num2str(media_misspercent), '%'));
            disp(strcat('Porcentagem de acerto em media =',32, num2str(media_hitpercent), '%'));
            disp('\\\');



%% mostrar imagens de acerto && acerto
img_hit = readimage(trainCell, d_hit);
img_test_hit = readimage(testCell, test_hit);
figure; imshowpair(img_hit, img_test_hit, 'montage');

img_error = readimage(trainCell, d_error);
img_test_error = readimage(testCell, test_error);
figure; imshowpair(img_error, img_test_error, 'montage');