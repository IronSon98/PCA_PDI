clear; clc; close all;

originalpath = pwd();
pathdestiny = strcat(originalpath, '\Dataset_JAFFE_pdi\Emocoes\');
path = strcat(originalpath, '\Dataset_Japas\Dataset\Emocoes\');
classes = ["AN", "DI", "FE", "HA", "NE", "SA", "SU"];

classnumber = 7;
imagetoload = 20;

cd(path);

for i = 1 : classnumber
    classname = classes(i);
    foldername = strcat(path,classname);
    foldernamedestiny = strcat(pathdestiny,classname);
    for k = 1 : imagetoload
        filename = strcat(foldername, '\', classname, int2str(k), '.tiff');
        filedestiny = strcat(foldernamedestiny, '\', classname, int2str(k), '.tiff');
        tmp = imread(filename);
        tmp = imcrop(tmp, [75 ,80, 110, 150]);
        %tmp =  imcrop(tmp, [75 ,80, 111, 149]);
        %tmp = imsharpen(tmp);
%       tmp = imnoise(tmp, 'gaussian', 0,9);
        imwrite(tmp, filedestiny);
    end
end

chdir(originalpath);
clear all; close all;