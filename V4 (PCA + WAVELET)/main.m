%Superf�cie     C�digo
%------------------------
%Capim          RT21
%Folhas         RT7
%Madeira        RT19
%Piso           RT22
%Rochas         RT3
%Tapete         RT24
%Tijolos        RT8    

clear all, close all 

cd('C:\Users\pedri\OneDrive\�rea de Trabalho\Semestre atual\PDI\PCA_PDI\V4 (PCA + WAVELET)\');
path = 'C:\Users\pedri\OneDrive\�rea de Trabalho\Semestre atual\PDI\PCA_PDI\Dataset\'; 

%Leitura da base de dados
imds = imageDatastore(path,'IncludeSubfolders',true,'LabelSource','foldernames');

sn = waveletScattering2 ('ImageSize' , [320 240], 'InvarianceScale' , 150);
n_executions = 100; %N�mero de execu��es
n_class = 7; %Total de classes
hits_accuracy = zeros(1, n_executions); %Vetor com as acur�cias de acerto
faults_accuracy = zeros(1, n_executions); %Vetor com as acur�cias de erro
accuracy_class_media(:, n_class) = 0; %Vetor com as m�dias de acur�cia de acertos por classe
hits_testCell(n_executions, :) = 0; %Matriz com todos os acertos de teste
hits_trainCell(n_executions, :) = 0; %Matriz com todos os acertos de treino
faults_testCell(n_executions, :) = 0; %Matriz com todos os erros de teste
faults_trainCell(n_executions, :) = 0; %Matriz com todos os erros de treino
s_hits_accuracy = 0; %Somat�rio das acur�cias de acerto
s_faults_accuracy = 0; %Somat�rio das acur�cias de erro
best_accuracy = 0; %Melhor acur�cia de todas as execu��es
flagHit = 0; %Verifica se em uma das execu��es teve pelo menos 1 acerto
flagFault = 0; %Verifica se em uma das execu��es teve pelo menos 1 erro

for k = 1:n_executions
    %Sele��o das imagens para treino e teste
    [trainCell, testCell] = splitEachLabel(imds, 0.7, 'randomized');

    n_test = size(testCell.Files, 1); %N�mero de testes
    n_train = size(trainCell.Files, 1); %N�mero de treinos
    train = n_train /n_class; %N�mero de Treino por classes 
    test = n_test /n_class; %N�mero de Teste por classes 
    sample = train + test; %Amostra
    
    %Gera��o da base de treinamento
    data_train = lerImgs(trainCell, n_train);

    %Gera��os de PCS
    [P, PC, mn] = GerarPCs(data_train);

    %Declara��o de vari�veis
    hits = 0;
    faults = 0;
    hits_class = zeros(1, n_class);
    accuracy_class = zeros(1, n_class);

    %Realiza��o dos testes
    for i=1:n_test
        img_test = readimage(testCell, i);
        d = Classificar(PC, ProjetarAmostra(img_test,mn,P,sn));

        %C�lculo e armazenamento dos acertos e erros
        if trainCell.Labels(d) == testCell.Labels(i)
            flagHit = 1;
            
            pos_class = ceil(d/train);
            hits_class(pos_class) = hits_class(pos_class) + 1;
            
            hits = hits + 1;
            hits_trainCell(k, hits) = d;
            hits_testCell(k, hits) = i;
        else
            flagFault = 1;
            
            faults = faults + 1;
            faults_trainCell(k, faults) = d;
            faults_testCell(k, faults) = i;
        end
    end

    %C�lculo da acur�cia de acertos e erros de uma execu��o x
    hits_accuracy(k) = (hits/n_test)*100;
    faults_accuracy(k) = (faults/n_test)*100;
    
    %Verifica��o da melhor acur�cia
    if hits_accuracy(k) > best_accuracy
        best_accuracy = hits_accuracy(k);
    end
    
    %Somat�rio de todas as ac�racias de acertos e erros
    s_hits_accuracy = s_hits_accuracy +  hits_accuracy(k);
    s_faults_accuracy = s_faults_accuracy +  faults_accuracy(k);

    disp("Execu��o n�mero: " + num2str(k));
    disp("�ndice de acertos: " + num2str(hits_accuracy(k)) + "%");
    disp("�ndice de erros: " + num2str(faults_accuracy(k)) + "%");
    disp("Quantidade de imagens de teste: " + num2str(n_test));
    disp("Quantidade de acertos: " + num2str(hits));
    for i = 1:n_class
        accuracy_class(i) = (hits_class(i)/test)*100;
        disp("Acur�cia Classe " + char(trainCell.Labels(i*train)) + ' = ' + num2str(accuracy_class(i)) + "%");
        accuracy_class_media(i) = accuracy_class_media(i) + accuracy_class(i);
    end
    disp("-----------------------------------------------");
end

%C�lculo da m�dia de acur�cias de acertos e erros
media_hits_accuracy = s_hits_accuracy/n_executions;
media_faults_accuracy = s_faults_accuracy/n_executions;

disp(" ");
disp("***********************************************");
disp("M�dia de acertos: " + num2str(media_hits_accuracy) + "%");
disp("M�dia de erros: " + num2str(media_faults_accuracy) + "%");
disp("Melhor acur�cia: " + num2str(best_accuracy) + "%");
for i=1:n_class
    accuracy_class_media(i) = (accuracy_class_media(i)/n_executions);
    disp("Acur�cia Classe " + char(trainCell.Labels(i*train)) + ' = ' + num2str(accuracy_class_media(i)) + "%");
end
disp("***********************************************");

%Exemplo de acerto (se tiver)
if flagHit ~= 0
    img_train_hit = readimage(trainCell, hits_trainCell(n_executions, 1));
    img_test_hit = readimage(testCell, hits_testCell(n_executions, 1));

    figure; imshowpair(img_train_hit, img_test_hit, 'montage');

    title("Exemplo de Acerto");
end

%Exemplo de erro (se tiver)
if flagFault ~= 0
    img_train_fault = readimage(trainCell, faults_trainCell(n_executions, 1));
    img_test_fault = readimage(testCell, faults_testCell(n_executions, 1));

    figure; imshowpair(img_train_fault, img_test_fault, 'montage');

    title("Exemplo de Erro");
end