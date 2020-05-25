function z = x(trainCell, n_train)
z = [];
for i = 1:n_train
    img_train = readimage(trainCell, i);
    y = reshape(img_train,[size(img_train,1)*size(img_train,2),1]);
    z = [z, y];
end
end
