% Example

addpath('utils');
addpath('Functions');
addpath('Filter');
addpath('rwt-master/bin');
addpath('ncuts');

fprintf('CameraIdentification main script\n\n');

imgpath = '../dataset/images/';  %dataset path
validationPath = '../dataset/validation'; %validation path

sourcePath = 'source/'; %where prnu data are stored (inside mat folder)
outputPath = 'output/'; %where reference pattern are store (inside mat folder)

numFolders = 3; %number of folders
numImages = 5; %number of images from each folder
imgtype = 'imgs_nat';


%% Reference patterns extraction %%

% Script for extracting and saving camera reference patters

% 1) Extracts images PRNU and store them in source path directory
% 2) Resizes PRNU to the same dimensions (for further processing)
% 3) Computes weights matrix with PCE distances between each PRNU
% 4) Clustering of images wrt weight matrix usign normalized cuts
% 5) Reference pattern for each camera evaluation
% 6) Store reference patterns in output path, cameras subfolder

%If called with ExtractNoise set to false, PRNU and weight matrix are not
%exracted and proceed to the reference patterns generation using weight
%matrix found in source path


CameraIdentification(imgpath, imgtype, 'NumFolders', numFolders, 'NumImages', ...
        numImages, 'ExtractNoise', true, 'SourcePath', ...
        sourcePath, 'OutputPath', outputPath, 'Threshold', 4*10^-5);    
    

%% Validation %%
% Predict and evaluate results for prediction on a validation set

% 1) Calls CameraValidation for each images in validation path (given num
% folders and number of images from each folder)
% 2) Plot confusion matrix of the results

Validation(validationPath, imgtype, 'NumFolders', numFolders, ...
        'NumImages', 5, 'OutputPath', outputPath);
                                    
