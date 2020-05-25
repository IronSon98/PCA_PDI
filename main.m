%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Arlindo Galvão - PDI2019 %%
%%        MAIN             %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all, close all
    
cd('F:\Backup\Desktop\Faculdade\9º Período\Visão Computacional - OP\PCA\')

path = 'F:\Backup\Desktop\Faculdade\9º Período\Visão Computacional - OP\PCA\Dataset_JAFFE_pdi\Emocoes\';
%path = 'F:\Backup\Desktop\Faculdade\9º Período\Visão Computacional - OP\PCA\Dataset_Japas\Dataset\Faces\';
n_class = 7;

imds = imageDatastore(path,'IncludeSubfolders',true,'LabelSource','foldernames');
[trainCell, testCell] = splitEachLabel(imds, 0.7, 0.3);

bag = bagOfFeatures(imds, 'StrongestFeatures', 1.0, 'PointSelection', 'Detector');


n_train = size(trainCell.Files, 1);
n_test = size(testCell.Files, 1);

train = n_train/n_class;
test = n_test/n_class;
sample = train + test;

data = lerImgs(trainCell, n_train(1), bag);

[P PC mn] = GerarPCs(data);

hits = 0; 
hit_class(:, n_class) = 0;
flag = 0;

for i=1:n_test(1)
        %x = imcrop(x, [75 ,80, 110, 150]);
        img_test = readimage(testCell, i);
        features = encode(bag, img_test);
        features = features';
        d_min = Classificar(PC, ProjetarAmostra(features, mn, P));
        
        % Acuracy & Examples
        if trainCell.Labels(d_min) == testCell.Labels(i)
            idx_class = d_min/train;
            idx_class = ceil(idx_class);
            hit_class(idx_class) = hit_class(idx_class) + 1;
            
            hits = hits + 1;
            d_hit = d_min;
            test_hit = i;
        else
            flag = 1;
            d_error = d_min;
            test_error = i;
        end
end
acuracy = (hits/n_test)*100;
disp("Acurácia Total = " + num2str(acuracy) + "%");

acuracy_class(:, n_class) = 0;

for i=1:n_class
   acuracy_class(i) = (hit_class(i)/test)*100;
   disp("Acurácia Classe " + char(trainCell.Labels(i*train)) + ' = ' + num2str(acuracy_class(i)) + "%");
end

img_hit = readimage(trainCell, d_hit);
img_test_hit = readimage(testCell, test_hit);
figure; imshowpair(img_hit, img_test_hit, 'montage');
title(char(trainCell.Labels(d_hit)) + "          |          " + char(testCell.Labels(test_hit)));

if flag ~= 0
    img_error = readimage(trainCell, d_error);
    img_test_error = readimage(testCell, test_error);
    figure; imshowpair(img_error, img_test_error, 'montage');
    title(char(trainCell.Labels(d_error)) + "          |          " + char(testCell.Labels(test_error)));
end