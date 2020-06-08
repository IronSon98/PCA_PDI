function [trainCell, testCell] = ChangeDirectories(trainCell, testCell, str_current)
    labels_train = trainCell.Labels;
    labels_test = testCell.Labels;
    
    size_train = size(trainCell.Files, 1);
    train = cell(size_train, 1);
    
    for i=1:size_train
        str_change = trainCell.Files(i, 1);
        str_change = char(str_change);
        aux = size(str_change, 2); 
        str_change = str_change(102:aux);
        str_change = strcat(str_current, str_change);
        str_change = cellstr(str_change);
        train(i, 1) = str_change;
    end

    size_test = size(testCell.Files, 1);
    test = cell(size_test, 1);
    
    for i=1:size_test
        str_change = testCell.Files(i, 1);
        str_change = char(str_change);
        aux = size(str_change, 2); 
        str_change = str_change(102:aux);
        str_change = strcat(str_current, str_change);
        str_change = cellstr(str_change);
        test(i, 1) = str_change;
    end
    
    trainCell.Files(:, 1) = '';
    testCell.Files(:, 1) = '';
    
    trainCell.Files = train;
    testCell.Files = test; 
    
    trainCell.Labels = labels_train;
    testCell.Labels = labels_test;
end
