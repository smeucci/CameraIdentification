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

numImages = 50;
random = false;
warning off;

%imgs nat%
type = 'imgs_nat';

try
    CameraIdentification(imgpath, type, 'NumFolders', 4, 'NumImages', ...
        numImages, 'ExtractNoise', false, 'Random', random, 'OutputPath', 'imgs_nat_4/', 'Offset', 4);
    
    CameraIdentification(imgpath, type, 'NumFolders', 5, 'NumImages', ...
        numImages, 'ExtractNoise', false, 'Random', random, 'OutputPath', 'imgs_nat_5/', 'Offset', 7);
    
    CameraIdentification(imgpath, type, 'NumFolders', 6, 'NumImages', ...
        numImages, 'ExtractNoise', false, 'Random', random, 'OutputPath', 'imgs_nat_6/', 'Offset', 0);

    %facebook% 
    type = 'imgs_nat_fb_highres';

    CameraIdentification(imgpath, type, 'NumFolders', 4, 'NumImages', ...
        numImages, 'ExtractNoise', false, 'Random', random, 'OutputPath', 'imgs_nat_fb_highres_4/', 'Offset', 4);
    
    CameraIdentification(imgpath, type, 'NumFolders', 5, 'NumImages', ...
        numImages, 'ExtractNoise', false, 'Random', random, 'OutputPath', 'imgs_nat_fb_highres_5/', 'Offset', 7);
    
    CameraIdentification(imgpath, type, 'NumFolders', 6, 'NumImages', ...
        numImages, 'ExtractNoise', false, 'Random', random, 'OutputPath', 'imgs_nat_fb_highres_6/', 'Offset', 0);
catch
   disp('errore'); 
end
exit;

%
%load('mat/imgs_nat_fb_highres/images_weights.mat', 'weights');
%[tprs, fprs, thresholds] = crossvalidateThreshold(imgpath, type, 12, 30, w, -10^-4:10^-5:10^-3, 'NC', outputPath, 0);

%    CameraIdentification(imgpath, type, 'NumFolders', numFolders, 'NumImages', ...
%        numImages, 'ExtractNoise', false, 'Random', random, 'OutputPath', outputPath);
    
%    type = 'imgs_nat_fb_highres';
%    outputPath = [type '/'];
    
%    CameraIdentification(imgpath, type, 'NumFolders', numFolders, 'NumImages', ...
%        numImages, 'ExtractNoise', true, 'Random', random, 'OutputPath', outputPath);

%load('mat/images_weights.mat', 'weights');
%[th, acc] = crossvalidateThreshold(imgpath, 14, 30, weights, 0:10^-6:10^-3, 'NC');
%fprintf('\nBest threshold NC: %f, accuracy: %f', th, acc);

%[th, acc] = crossvalidateThreshold(imgpath, 14, 30, weights, 0.9:10^-5:1, 'AC');
%fprintf('\nBest threshold AC: %f, accuracy: %f', th, acc);

%CameraIdentification(imgpath, type, 'NumFolders', numFolders, 'NumImages', ...
%    numImages, 'ExtractNoise', true, 'Random', random);

    %confusionMatrix = Validation(imgpath, type, 'NumFolders', numFolders, 'NumImages', 10, 'OutputPath', outputPath);
    %save('mat/confusionMatrix.mat', 'confusionMatrix');
%catch
%   disp('errore'); 
%end
%exit;