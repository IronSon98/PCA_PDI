function z = lerImgs(trainCell, n_train)
    %z(256*256*3, n_train) = 0;
    z = [];
    sn = waveletScattering2 ('ImageSize' , [960 1280]);
    for i = 1:n_train
        img_train = readimage(trainCell, i);
%         img_train = imresize(img_train, [320 240]);
        Feature = featureMatrix(sn, img_train,'Transform','log');
        Feature = mean(mean(Feature,2),3);
        z(:, i) = [Feature];
    end
end
