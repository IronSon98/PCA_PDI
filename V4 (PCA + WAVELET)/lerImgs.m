function z = lerImgs(trainCell, n_train)
    %z(256*256*3, n_train) = 0;
    z = [];
    sn = waveletScattering2 ('ImageSize' , [320 240], 'InvarianceScale' , 150);
    for i = 1:n_train
        img_train = readimage(trainCell, i);
        img_train = imresize(img_train, [320 240]);
        Feature = featureMatrix(sn, img_train);
        Feature = mean(mean(Feature,2),3);
        %img_train = reshape(img_train,[size(img_train,1)*size(img_train,2),1]);
%       LBP = extractLBPFeatures(img_train, 'Upright' , false);
        %features = [img_train, features];
        %features = reshape(features, [size(features,1)*size(features,2), 1]);
        %z(:, i) = [features];
        z(:, i) = [Feature];
    end
end
