function z = x(trainCell , n_train)
z = [];
p = 1;
cellsize = [44 44];

    for k = 1:n_train
            x = readimage(trainCell,k);
            x = imcrop(x, [75 ,80, 111, 149]);
%         featureHog = extractHOGFeatures(x, 'CellSize',cellsize);
            hog2 = extractHOGFeatures(x);
            z(p,:) = hog2;
            p = p + 1;
    end
end