function z = x(classname, n_class, n_train)
z = [];
for j = 1:n_class
    %1º parâmetro: endereço da pasta de imagens
    filename = strcat('C:\Users\pedri\OneDrive\Área de Trabalho\Semestre atual\PDI\Lista 6\PCA_PDI\Dataset\Emocoes\',classname(j), '\');  % COLOQUE O ENDEREÇO !!!!
    cd(filename)
    for k = 1:n_train
        x = imread(strcat(classname(j), int2str(k),'.tiff'));
        x = imcrop(x, [75 ,80, 110, 150]);
        points = detectSURFFeatures(x);
        p = points.selectStrongest(20);
        [features, valid_points] = extractFeatures(x, p);
        features = (features - min(features))/(max(features) - min(features));
        y = reshape(features,[size(features,1)*size(features,2),1]);
        z = [z , y];
    end
end
end