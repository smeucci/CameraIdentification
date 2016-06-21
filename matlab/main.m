% Camera images clustering for camera identification main script
% ----------------------------------------------------
% Authors: Lorenzo Cioni, Saverio Meucci
% ----------------------------------------------------

addpath('utils');
addpath('Functions');
addpath('Filter');
addpath('rwt-master/bin');
addpath('ncuts');

fprintf('CameraIdentification main script\n\n');

imgpath = '../dataset/images/';
validationPath = '../dataset/validation';

numImages = 50;
random = false;
warning off;


try
    %imgs nat%
    type = 'imgs_nat';
%     CameraIdentification(imgpath, type, 'NumFolders', 4, 'NumImages', ...
%         numImages, 'ExtractNoise', false, 'Random', random, 'OutputPath', 'imgs_nat_4/', 'Offset', 4);
%     
%     CameraIdentification(imgpath, type, 'NumFolders', 5, 'NumImages', ...
%         numImages, 'ExtractNoise', false, 'Random', random, 'OutputPath', 'imgs_nat_5/', 'Offset', 7);
%     
%     CameraIdentification(imgpath, type, 'NumFolders', 6, 'NumImages', ...
%         numImages, 'ExtractNoise', false, 'Random', random, 'OutputPath', 'imgs_nat_6/', 'Offset', 0);

    Validation(validationPath, type, 'NumFolders', 4, 'NumImages', 20, 'OutputPath', 'imgs_nat_4/', 'Offset', 4);
    Validation(validationPath, type, 'NumFolders', 5, 'NumImages', 20, 'OutputPath', 'imgs_nat_5/', 'Offset', 7);
    Validation(validationPath, type, 'NumFolders', 6, 'NumImages', 20, 'OutputPath', 'imgs_nat_6/', 'Offset', 0);


    %facebook% 
    type = 'imgs_nat_fb_highres';
    
    Validation(validationPath, type, 'NumFolders', 4, 'NumImages', 20, 'OutputPath', 'imgs_nat_fb_highres_4/', 'Offset', 4);
    Validation(validationPath, type, 'NumFolders', 5, 'NumImages', 20, 'OutputPath', 'imgs_nat_fb_highres_5/', 'Offset', 7);
    Validation(validationPath, type, 'NumFolders', 6, 'NumImages', 20, 'OutputPath', 'imgs_nat_fb_highres_6/', 'Offset', 0);

%     CameraIdentification(imgpath, type, 'NumFolders', 4, 'NumImages', ...
%         numImages, 'ExtractNoise', false, 'Random', random, 'OutputPath', 'imgs_nat_fb_highres_4/', 'Offset', 4);
%     
%     CameraIdentification(imgpath, type, 'NumFolders', 5, 'NumImages', ...
%         numImages, 'ExtractNoise', false, 'Random', random, 'OutputPath', 'imgs_nat_fb_highres_5/', 'Offset', 7);
%     
%     CameraIdentification(imgpath, type, 'NumFolders', 6, 'NumImages', ...
%         numImages, 'ExtractNoise', false, 'Random', random, 'OutputPath', 'imgs_nat_fb_highres_6/', 'Offset', 0);
catch
   disp('errore'); 
end
exit;

%[th, acc] = crossvalidateThreshold(imgpath, 14, 30, weights, 0:10^-6:10^-3, 'NC');
%fprintf('\nBest threshold NC: %f, accuracy: %f', th, acc);

%[th, acc] = crossvalidateThreshold(imgpath, 14, 30, weights, 0.9:10^-5:1, 'AC');
%fprintf('\nBest threshold AC: %f, accuracy: %f', th, acc);

    %confusionMatrix = Validation(imgpath, type, 'NumFolders', numFolders, 'NumImages', 10, 'OutputPath', outputPath);
    %save('mat/confusionMatrix.mat', 'confusionMatrix');
%catch
%   disp('errore'); 
%end
%exit;