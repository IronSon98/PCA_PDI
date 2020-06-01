function z = lerImgs(trainCell, n_train)
    z = [];
    for i = 1:n_train
        img_train = readimage(trainCell, i);
        img_train = imresize(img_train, [256 256]);
        y = reshape(img_train,[size(img_train,1)*size(img_train,2),1]);
        z = [z, y];
    end
end
