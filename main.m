%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Arlindo Galvão - PDI2020 %%
%%        MAIN             %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all, close all
  
cd('F:\Backup\Desktop\Faculdade\9º Período\Visão Computacional - OP\PCA\')

path = 'F:\Backup\Desktop\Faculdade\9º Período\Visão Computacional - OP\Dataset_surfaces\Surfaces';
n_class = 7;

imds = imageDatastore(path,'IncludeSubfolders',true,'LabelSource','foldernames');
n_iter = 100;
acuracy_iter = 0;
acuracy_class_iter(:, n_class) = 0;

for k=1:n_iter
    
    [trainCell, testCell] = splitEachLabel(imds, 0.7, 'randomized');

    n_train = size(trainCell.Files, 1);
    n_test = size(testCell.Files, 1);

    train = n_train/n_class;
    test = n_test/n_class;
    sample = train + test;

    data = lerImgs(trainCell, n_train);

    [P PC mn] = GerarPCs(data);

    hits = 0; 
    hit_class(:, n_class) = 0;
    hit_class(:, :) = 0;
    flag = 0;

    for i=1:n_test(1)
            %x = imcrop(x, [75 ,80, 110, 150]);
            img_test = readimage(testCell, i);
            d_min = Classificar(PC, ProjetarAmostra(img_test, mn, P));

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
    acuracy_iter = acuracy_iter + ((hits/n_test)*100);
    disp("Acurácia Iteração "+ int2str(k) + " = " + num2str((hits/n_test)*100) + "%");
    for j=1:n_class
        acuracy_class_iter(j) =  acuracy_class_iter(j) + ((hit_class(j)/test)*100);
    end
end

acuracy = acuracy_iter/n_iter;
disp("Acurácia Média Total = " + num2str(acuracy) + "%");
acuracy_class(:, n_class) = 0;

for z=1:n_class
    acuracy_class(z) = (acuracy_class_iter(z)/n_iter);
    disp("Acurácia Classe " + char(trainCell.Labels(z*train)) + ' = ' + num2str(acuracy_class(z)) + "%");
end

figure; bar(acuracy_class);

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

% n = 1;
% while n ~= 0
%     n = input("Número da imagem a ser classificada(1 à " + int2str(n_test) + "):");
%     if n ~=0
%         img_test = readimage(testCell, n);
%         d_min = Classificar(PC, ProjetarAmostra(img_test, mn, P));
% 
%         if trainCell.Labels(d_min) == testCell.Labels(i)           
%             d_hit = d_min;
%             test_hit = n;
%             img_hit = readimage(trainCell, d_hit);
%             img_test_hit = readimage(testCell, test_hit);
%             figure; imshowpair(img_hit, img_test_hit, 'montage');
%             title(char(trainCell.Labels(d_hit)) + "          |          " + char(testCell.Labels(test_hit)));
%         else
%             d_error = d_min;
%             test_error = n;
%             img_error = readimage(trainCell, d_error);
%             img_test_error = readimage(testCell, test_error);
%             figure; imshowpair(img_error, img_test_error, 'montage');
%             title(char(trainCell.Labels(d_error)) + "          |          " + char(testCell.Labels(test_error)));
%         end
%     end
% end