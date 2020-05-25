function z = x(trainCell , n_train, cellsize)
z = [];
for k = 1:n_train
    x = readimage(trainCell,k);
    x = imcrop(x, [75 ,80, 111, 149]);
    y = reshape(x,[size(x,1)*size(x,2),1]);
    y = single(y);
    y = y';
    featureHog = extractHOGFeatures(x, 'CellSize',cellsize);
    z(k,:) = [y, featureHog];
end
end