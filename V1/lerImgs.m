function z = lerImgs(trainCell, n_train)
    %z(256*256*3, n_train) = 0;
    z = [];
    for i = 1:n_train
        img_train = readimage(trainCell, i);
        img_train = imresize(img_train, [256 256]);
        %img_train = reshape(img_train,[size(img_train,1)*size(img_train,2),1]);
        LBP = extractLBPFeatures(img_train, 'NumNeighbors', 8, 'Radius', 1, 'Upright', false, 'Interpolation', 'Nearest', 'CellSize', [32 32], 'Normalization', 'None');
        %features = [img_train, features];
        %features = reshape(features, [size(features,1)*size(features,2), 1]);
        %z(:, i) = [features];
        z(:, i) = [LBP];
    end
end