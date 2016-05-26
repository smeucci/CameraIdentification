% Camera images clustering for camera identification main script
% ----------------------------------------------------
% Authors: Lorenzo Cioni, Saverio Meucci
% ----------------------------------------------------

addpath('utils');
addpath('Functions');
addpath('Filter');
addpath('rwt-master/bin');
addpath('ncuts');

imgpath = '../dataset';
type = 'imgs_nat';
numImages = 50;
numFolders = 14;
random = false;

fprintf('CameraIdentification main script\n\n');

CameraIdentification(imgpath, type, 'NumFolders', numFolders, 'NumImages', ...
    numImages, 'ExtractNoise', true, 'Random', random);

%load('mat/images_weights.mat', 'weights');
%[th, acc] = crossvalidateThreshold(imgpath, 14, 30, weights, 0:10^-6:10^-3, 'NC');
%fprintf('\nBest threshold NC: %f, accuracy: %f', th, acc);

%[th, acc] = crossvalidateThreshold(imgpath, 14, 30, weights, 0.9:10^-5:1, 'AC');
%fprintf('\nBest threshold AC: %f, accuracy: %f', th, acc);

%CameraIdentification(imgpath, type, 'NumFolders', numFolders, 'NumImages', ...
%    numImages, 'ExtractNoise', true, 'Random', random);

confusionMatrix = Validation(imgpath, 'imgs', 'NumFolders', 14, 'NumImages', 10);
save('mat/confusionMatrix.mat', 'confusionMatrix');


exit;