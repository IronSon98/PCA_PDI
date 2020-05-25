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

teste123 = 1;

clear all, close all 

cd('C:\Users\Iron Santana Filho\Desktop\Faculdade\Processamento Digital de Imagens\Lista 6\PCA_PDI\');

path = 'C:\Users\Iron Santana Filho\Desktop\Faculdade\Processamento Digital de Imagens\Lista 6\Base de dados\Emocoes\'; 

imds = imageDatastore(path,'IncludeSubfolders',true,'LabelSource','foldernames');

n_executions = 100;
n_class = 7; %Total de classes
hits_accuracy = [];
faults_accuracy = [];
accuracy_class_media(:, n_class) = 0;
accuracy_class = [];

for k = 1:n_executions
    [trainCell, testCell] = splitEachLabel(imds, 0.7, 'randomized');

    n_test = size(testCell.Files, 1);
    n_train = size(trainCell.Files, 1);
    train = n_train /n_class; %Número de Treino por classes 
    test = n_test /n_class; %Número de Teste por classes 
    
    data_train = lerImgs(trainCell, n_train);

    [P PC mn] = GerarPCs(data_train);

    hits = 0;
    faults = 0;
    hits_testCell = [];
    hits_trainCell = [];
    faults_testCell = [];
    faults_trainCell = [];
    hits_class = zeros(n_class);

    for i=1:n_test
        img_test = readimage(testCell, i);
        d = Classificar(PC, ProjetarAmostra(img_test,mn,P));

        if trainCell.Labels(d) == testCell.Labels(i)
            pos_class = ceil(d/train);
            hits_class(pos_class) = hits_class(pos_class) + 1;
            
            hits = hits + 1;
            hits_testCell(hits) = i;
            hits_trainCell(hits) = d;
        else
            faults = faults + 1;
            faults_testCell(faults) = i;
            faults_trainCell(faults) = d;
        end
    end

    hits_accuracy(k) = (hits/n_test)*100;
    faults_accuracy(k) = (faults/n_test)*100;

    disp("Execução número: " + num2str(k));
    disp("Índice de acertos: " + num2str(hits_accuracy(k)) + "%");
    disp("Índice de erros: " + num2str(faults_accuracy(k)) + "%");
    disp("Quantidade de imagens de teste: " + num2str(n_test));
    disp("Quantidade de acertos: " + num2str(hits));
    for i = 1:n_class
        accuracy_class(i) = (hits_class(i)/test)*100;
        disp("Acurácia Classe " + char(trainCell.Labels(i*train)) + ' = ' + num2str(accuracy_class(i)) + "%");
        accuracy_class_media(i) = accuracy_class_media(i) + accuracy_class(i);
    end
    disp("-----------------------------------------------");
end

s_hits_accuracy = 0;
s_faults_accuracy = 0;
best_accuracy = 0;

for k=1:n_executions
    if hits_accuracy(k) > best_accuracy
        best_accuracy = hits_accuracy(k);
    end
    s_hits_accuracy = s_hits_accuracy +  hits_accuracy(k);
    s_faults_accuracy = s_faults_accuracy +  faults_accuracy(k);
end

media_hits_accuracy = s_hits_accuracy/n_executions;
media_faults_accuracy = s_faults_accuracy/n_executions;

disp(" ");
disp("***********************************************");
disp("Média de acertos: " + num2str(media_hits_accuracy) + "%");
disp("Média de erros: " + num2str(media_faults_accuracy) + "%");
disp("Melhor acurácia: " + num2str(best_accuracy) + "%");
for i=1:n_class
    accuracy_class_media(i) = (accuracy_class_media(i)/n_executions);
    disp("Acurácia Classe " + char(trainCell.Labels(i*train)) + ' = ' + num2str(accuracy_class_media(i)) + "%");
end
disp("***********************************************");

img_train_hit = readimage(trainCell, hits_trainCell(1));
img_test_hit = readimage(testCell, hits_testCell(1));

figure; imshowpair(img_train_hit, img_test_hit, 'montage');

title("Exemplo de Acerto");

img_test_fault = readimage(testCell, faults_testCell(1));
img_train_fault = readimage(trainCell, faults_trainCell(1));

figure; imshowpair(img_test_fault, img_train_fault, 'montage');

title("Exemplo de Erro");