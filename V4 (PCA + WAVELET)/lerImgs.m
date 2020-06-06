function z = lerImgs(trainCell, n_train, sn)
    z = [];
    for i = 1:n_train
        img_train = readimage(trainCell, i);
        %img_train = imresize(img_train, [320 240]);
        wav_feat = featureMatrix(sn, img_train,'Transform','log');
        features = mean(mean(wav_feat,2),3);
        z(:, i) = [features];
    end
end
