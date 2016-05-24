% Camera images clustering for camera identification main script
% ----------------------------------------------------
% Authors: Lorenzo Cioni, Saverio Meucci
% ----------------------------------------------------

imgpath = '../dataset';
type = 'imgs_nat';
numImages = 30;
numFolders = 14;
random = true;

fprintf('CameraIdentification main script');

CameraIdentification(imgpath, type, 'NumFolders', numFolders, 'NumImages', ...
    numImages, 'ExtractNoise', true, 'Random', random);

exit;