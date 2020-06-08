clear all, close all 

cd('F:\Backup\Desktop\Faculdade\9º Período\Processamento Digital de Imagens\Github\PCA_PDI\V7 (PCs + Classificação)\');

class = ["Capim", "Folhas", "Madeira", "Piso", "Rochas", "Tapete" ,"Tijolos"];

str_current = 'F:\Backup\Desktop\Faculdade\9º Período\Processamento Digital de Imagens\Github';

msg = 'Escolha a configuração para Treino/Teste: (1: 50/50 | 2: 60/40 | 3: 70/30) \n';
config = input(msg, 's');

if config == '1'
    str_load = '50-50';
elseif config == '2'
    str_load = '60-40';
elseif config == '3'
    str_load = '70-30';
else
    disp("Configuração inválida!");
    main_live
end

load(strcat('workspace_surf_', str_load, '.mat'));

[trainCell, testCell] = ChangeDirectories(trainCell, testCell, str_current);

flag = 1;

while(flag ~= 0)
    close all;
    if flag == 2
        msg = 'Escolha a configuração para Treino/Teste: (1: 50/50 | 2: 60/40 | 3: 70/30) \n';
        config = input(msg, 's');

        if config == '1'
            str_load = '50-50';
        elseif config == '2'
            str_load = '60-40';
        elseif config == '3'
            str_load = '70-30';
        else
            disp("Configuração inválida!");
            main_live
        end
        load(strcat('workspace_surf_', str_load, '.mat'));
        [trainCell, testCell] = ChangeDirectories(trainCell, testCell, str_current);
        flag = 1;
    end
    
    if flag == 1
        % Rotina de teste 
        pos_img = Classificar_live(n_test, n_class, class);
        pos_img
        img_test = readimage(testCell, pos_img);
        bag_features = encode(bag, img_test, 'Normalization', 'L2');
        d = Classificar(PC, ProjetarAmostra(bag_features, mn, P));

        %Cálculo e armazenamento dos acertos e erros
        if trainCell.Labels(d) == testCell.Labels(pos_img)
            img_train_hit = readimage(trainCell, d);
            img_test_hit = readimage(testCell, pos_img);

            figure; imshowpair(img_train_hit, img_test_hit, 'montage');

            title("Exemplo de Acerto");
        else
            img_train_fault = readimage(trainCell, d);
            img_test_fault = readimage(testCell, pos_img);

            figure; imshowpair(img_train_fault, img_test_fault, 'montage');

            title("Exemplo de Erro");
        end
    end
   
    msg = 'Testar outra imagem | Alterar Configuração | Sair: (1 | 2 | 3) \n';
    config = input(msg, 's');

    if config == '1'
        flag = 1;
    elseif config == '2'
        flag = 2;
    elseif config == '3'
        flag = 0;
    else
        disp("Opção inválida!");
        flag = 3;
    end
end

