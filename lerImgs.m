function z = x(classname, n_class, n_train)
z = [];
p = 1;
cel = 4;

for j = 1:n_class
    %1� par�metro: endere�o da pasta de imagens
    filename = strcat('C:\Users\pedri\OneDrive\�rea de Trabalho\Semestre atual\PDI\Lista 6\PCA_PDI\Dataset\Emocoes\',classname(j), '\');  % COLOQUE O ENDERE�O !!!!
    cd(filename)
    for k = 1:n_train
        x = imread(strcat(classname(j), int2str(k),'.tiff'));
        x = imcrop(x, [75 ,80, 111, 149]);
        hog2 = extractHOGFeatures(x);
        z(p,:) = hog2;
        p = p + 1;
    end
end
z = z';
end