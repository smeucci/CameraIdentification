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

imgpath = '../dataset/images/';  %dataset path
sourcePath = 'source/'; %where prnu data are stored
outputPath = 'output/'; %where reference pattern are store
validationPath = '../dataset/validation'; %validation path
numFolders = 4; %number of folders
numImages = 50; %number of images from each folder


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


CameraIdentification(imgpath, type, 'NumFolders', numFolders, 'NumImages', ...
        numImages, 'ExtractNoise', true, 'Random', random, 'SourcePath', ...
        sourcePath, 'OutputPath', outputPath);    
    
    
%% Image camera prediction %%
% Predict image source camera

% 1) Extracts filename PRNU
% 2) Resizes PRNU to the same dimensions of the found camera in output dir
% 3) Computes PCE distance between current PRNU and each reference pattern
% 4) Return the camera id with the best affinity value (PCE module)

[camera, affinity] = CameraValidation(filename, outputPath);


%% Validation %%
% Predict and evaluate results for prediction on a validation set

% 1) Calls CameraValidation for each images in validation path (given num
% folders and number of images from each folder)
% 2) Plot confusion matrix of the results

Validation(validationPath, type, 'NumFolders', numFolders, ...
        'NumImages', 20, 'OutputPath', outputPath);


%% Crossvalidate clustering threshold %%
% Crossvalidate thresholds for normalized cuts algorithm based on FRP and TPR in
% clustering operations

% weights : the weights matrix of PCE distance for that set of images
% range : the range to explore for thresholds
% type : type of normalized cuts thresholds, 'NC' or 'AC'

[tprs, fprs, thresholds] = crossvalidateThreshold(imgpath, numFolders, numImages, ...
                                        weights, range, type);
                                    