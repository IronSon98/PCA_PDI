% EMOÇÕES           % PESSOAS     
%-----------------------------
% AN: Angry         % KA         
% DI: Disgusting    % KL         
% FE: Fear          % KM         
% HA: Happy         % KR         
% NE: Neutral       % NA          
% SA: Sadness       % NM         
% SU: Surprise      % TM        
% ####              % UY          
% ####              % YM 

clear all, close all

treino = 0.7;
n_class = 10; %Total de classes
cellsize = [44 44];

cd('C:\Users\Iron Santana Filho\Desktop\Faculdade\Processamento Digital de Imagens\Lista 6\PCA_PDI\')

caminho = 'C:\Users\Iron Santana Filho\Desktop\Faculdade\Processamento Digital de Imagens\Lista 6\PCA_PDI\Dataset\Faces\';

imds = imageDatastore(caminho,'IncludeSubfolders',true,'LabelSource','foldernames');

n_executions = 100;
hitpercent = [];
acuracy_class_media(:,n_class) = 0;
acuracy_class = [];

for l = 1:n_executions
    [trainCell, testCell] = splitEachLabel(imds, treino, 'randomized');

    n_train = size(trainCell.Files,1); %Número de Treinos
    n_test = size(testCell.Files,1); %Número de Testes
    n_amostras = (n_train /n_class) + (n_test /n_class); %Total de Amostras
    train = n_train /n_class; %Número de Treino por classes 
    test = n_test /n_class; %Número de Teste por classes 

    data = lerImgs(trainCell ,n_train, cellsize);
    data = data';

    [P PC mn] = GerarPCs(data);

    hit = 0;
    hit_class = zeros(n_class);

    for i=1:n_test

        x = readimage(testCell, i);
        x = imcrop(x, [75 ,80, 111, 149]);    
        y = reshape(x,[size(x,1)*size(x,2),1]);
        y = single(y);
        y = y';
        featureHog = extractHOGFeatures(x, 'CellSize',cellsize);
        z = [y , featureHog];
        z = z';

        d = Classificar(PC, ProjetarAmostra(z,mn,P));

        if trainCell.Labels(d) == testCell.Labels(i)
            %Para acuracia por classes 
            pos_class = ceil(d/train);
            hit_class(pos_class) = hit_class(pos_class) + 1;
            hit = hit + 1;

            %Para mostrar a ultima imagem de acerto
            d_hit = d;
            test_hit = i;
        else
            %Para mostrar a ultima imagem de error
            d_error = d;
            test_error = i;
        end
    end
    
    hitpercent(l) = (hit/n_test) * 100;
    misspercent(l) = 100 - hitpercent(l);
    
    disp("Execução número: " + num2str(l));
    disp("Índice de acertos: " + num2str(hitpercent(l)) + "%");
    disp("Índice de erros: " + num2str(misspercent(l)) + "%");
    disp("Quantidade de imagens de teste: " + num2str(n_test));
    disp("Quantidade de acertos: " + num2str(hit));
    %mostrar acertos por classe e acertos acertos totais 
    for i = 1:n_class
        acuracy_class(i) = (hit_class(i)/test)*100;
        disp("Acurácia Classe " + char(trainCell.Labels(i*train)) + ' = ' + num2str(acuracy_class(i)) + "%");
        acuracy_class_media(i) = acuracy_class_media(i) + acuracy_class(i);
    end
    disp("-----------------------------------------------");
end

Sum_hitpercent = 0;
Sum_misspercent = 0;
best_accuracy = 0;

for i = 1:n_executions
    if hitpercent(i) > best_accuracy
        best_accuracy = hitpercent(i);
    end
    Sum_hitpercent = Sum_hitpercent +  hitpercent(i);
    Sum_misspercent = Sum_misspercent +  misspercent(i);
end

media_hitpercent = Sum_hitpercent/n_executions;
media_misspercent = Sum_misspercent/n_executions;

disp(" ");
disp("***********************************************");
disp("Média de acertos: " + num2str(media_hitpercent) + "%");
disp("Média de erros: " + num2str(media_misspercent) + "%");
disp("Melhor acurácia: " + num2str(best_accuracy) + "%");
for i=1:n_class
    acuracy_class_media(i) = (acuracy_class_media(i)/n_executions);
    disp("Acurácia Classe " + char(trainCell.Labels(i*train)) + ' = ' + num2str(acuracy_class_media(i)) + "%");
end
disp("***********************************************");

%mostrar imagens de acerto && acerto
img_hit = readimage(trainCell, d_hit);
img_test_hit = readimage(testCell, test_hit);

figure; imshowpair(img_hit, img_test_hit, 'montage');

title("Exemplo de Acerto");

img_error = readimage(trainCell, d_error);
img_test_error = readimage(testCell, test_error);

figure; imshowpair(img_error, img_test_error, 'montage');

title("Exemplo de Erro");