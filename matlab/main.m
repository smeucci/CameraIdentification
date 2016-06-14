% Camera images clustering for camera identification main script
% ----------------------------------------------------
% Authors: Lorenzo Cioni, Saverio Meucci
% ----------------------------------------------------

addpath('utils');
addpath('Functions');
addpath('Filter');
addpath('rwt-master/bin');
addpath('ncuts');

imgpath = '../dataset/images/';
type = 'imgs_nat';
numImages = 50;
numFolders = 12;
random = false;
outputPath = 'crossvalidation_imgs_nat_fb_highres/';

fprintf('CameraIdentification main script\n\n');

warning off;
%try
%load('mat/imgs_nat_fb_highres/images_weights.mat', 'weights');
%weights = weights(1:5*50, 1:5*50);
[tprs, fprs, thresholds] = crossvalidateThreshold(imgpath, type, 6, 30, w, 0:10^-3:0.05, 'AC', outputPath);

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