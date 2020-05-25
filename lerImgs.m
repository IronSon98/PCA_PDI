function z = x(im_data_store, n_train)
    z = [];
    for i = 1:n_train
            x = readimage(im_data_store, i);
            x = imresize(x, [320 240]);
            %texture_feat = extractLBPFeatures(x, 'CellSize', [32 32], 'Normalization', 'L2');
            %z(i, :) = [texture_feat];
            y = reshape(x,[size(x,1)*size(x,2),1]);
            z = [z, y];
    end
    %z = z';
end