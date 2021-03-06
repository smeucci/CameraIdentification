function [confusionMatrix] = Validation(imgpath, type, varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Validation script for camera images    %
%
%   INPUTS
%   Required parameters
%
%   imgpath  : path of reference images
%   type     : the types of the images (name of the folder)
%   
%   Optional parameters (key, value)
%   
%   'NumFolders' : number of folder to be used (default all)
%   'NumImages'  : number of images to be taken from each folder (default
%   all)
%
%   USAGE  confusionMatrix = Validation(imgpath, 'imgs', 'NumFolders', 4,
%                        'NumImages', 10)
%
%   OUTPUT
%   	confusion matrix
% ----------------------------------------------------
% Authors: Lorenzo Cioni, Saverio Meucci
% ----------------------------------------------------

    addpath('utils');
    
    p = inputParser;
    p.KeepUnmatched = true;
    defaultNumFolder = Inf;
    defaultNumImages = Inf;
    defaultOutputPath = '';
    defaultOffset = 0;
    
    addOptional(p,'OutputPath', defaultOutputPath);
    addOptional(p,'NumFolders', defaultNumFolder, @(x) isnumeric(x));
    addOptional(p,'NumImages', defaultNumImages, @(x) isnumeric(x));
    addOptional(p, 'Offset', defaultOffset, @(x) isnumeric(x));
    
    parse(p, varargin{:});
    numFolders = p.Results.NumFolders;
    numImages = p.Results.NumImages;
    outputPath = p.Results.OutputPath;
    offset = p.Results.Offset;

    fprintf('\nValidation script for camera identification\n');

    start_time = clock;
    images = getImagesPath(imgpath, type, 'NumFolders', numFolders, ...
                    'NumImages', numImages, 'Random', true, 'Offset', offset); 
    n_images = length(images);

    fprintf('Image processed: 0 / 0.00 %% - Elapsed time: 0.0 s\n');
    counter = 0;
    predictedLabels = cell(length(n_images), 1);
      for i = 1:n_images
          [cam, ~] = CameraValidation(images(i).filename, outputPath);
          predictedLabels{i} = cam;
          counter = counter + 1;
          fprintf('Image processed: %d / %.2f %%', counter, ...
                       (counter * 100/n_images));
          fprintf(' - Elapsed time: %.2f s\n', etime(clock, start_time));
      end
      
      
    if ~exist(['mat/' outputPath 'validation'], 'dir')
        mkdir(['mat/' outputPath 'validation']);
    end

    save(['mat/' outputPath 'validation/predictedLabels.mat'], 'predictedLabels');
    save(['mat/' outputPath 'validation/images_list.mat'], 'images');

    %load('mat/labels.mat', 'predictedLabels');

    [confusionMatrix, ~] = plotConfusionMatrix({images.camera}, predictedLabels, true, 'Confusion Matrix');

    save(['mat/' outputPath 'validation/confusion_matrix.mat'], 'confusionMatrix');
    
    correctClassified = sum(diag(confusionMatrix));
    imageNumber = sum(confusionMatrix(:));
    fprintf('Correctly classified images: %d / %d\n', correctClassified, imageNumber);
    accuracy = correctClassified/imageNumber;
    fprintf('Accuracy: %.2f %%\n', accuracy * 100);
end
