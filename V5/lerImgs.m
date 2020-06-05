function z = lerImgs(trainCell, n_train, sn, bag)
    %z(256*256*3, n_train) = 0;
    z = [];
    for i = 1:n_train
        img_train = readimage(trainCell, i);
        img_train = imresize(img_train, [640 480]);
        %img_train = reshape(img_train,[size(img_train,1)*size(img_train,2),1]);
        %LBP = extractLBPFeatures(img_train, 'NumNeighbors', 4, 'Radius', 1, 'Upright', false, 'Interpolation', 'Nearest', 'CellSize', [4 4], 'Normalization', 'L2');
        bag_feat = encode(bag, img_train);
        bag_feat = bag_feat';
        wav_feat = helperScatImages_mean(sn, img_train);
        %features = [img_train, features];
        %features = reshape(features, [size(features,1)*size(features,2), 1]);
        features = [bag_feat; wav_feat];
        z(:, i) = [features];
    end
end
