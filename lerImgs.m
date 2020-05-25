function z = x(im_data_store, n_train, bag_features)
    z = [];
    for i = 1:n_train
            img = readimage(im_data_store, i);
            features = encode(bag_features, img);
            z(i, :) = [features];     
    end
    z = z';
end