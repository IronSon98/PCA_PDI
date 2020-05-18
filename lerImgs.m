function z = x(classname, n_class, n_train)
z = [];
for j = 1:n_class
    %1º parâmetro: endereço da pasta de imagens
    filename = strcat('F:\Backup\Desktop\Faculdade\9º Período\Visão Computacional - OP\PCA\Dataset_Japas\Dataset\Emocoes\',classname(j), '\');  % COLOQUE O ENDEREÇO !!!!
    cd(filename)
    for k = 1:n_train
        x = imread(strcat(classname(j), int2str(k),'.tiff'));
        y = reshape(x,[size(x,1)*size(x,2),1]);
        z = [z , y];
    end
end
end