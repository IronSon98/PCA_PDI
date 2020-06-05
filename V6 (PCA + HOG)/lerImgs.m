function z = lerImgs(trainCell, n_train, CellSize)
    z = [];
    for i = 1:n_train
        img_train = readimage(trainCell, i);
        y = reshape(img_train,[size(img_train,1)*size(img_train,2),1]);
        y = single(y);
        y = y';
        featureHOG = extractHOGFeatures(img_train, 'CellSize', CellSize);
        z(:, i) = [y, featureHOG];
    end
end
