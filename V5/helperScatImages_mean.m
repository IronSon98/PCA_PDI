function features = helperScatImages_mean(sf,x)
    x = imresize(x,[200 200]);
    smat = featureMatrix(sf,x);
    features = mean(mean(smat,2),3);
end