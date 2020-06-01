%Leitura e tratamento das imagens de treino
function z = lerImgs(img_data_store, n_train, bag)
    z = [];
    for i = 1:n_train
            img = readimage(img_data_store, i);
            img = imresize(img, [256 256]);
            bag_features = encode(bag, img, 'Normalization', 'L2');
            x = bag_features;
            z(i, :) = [x];
    end
    z = z';
end