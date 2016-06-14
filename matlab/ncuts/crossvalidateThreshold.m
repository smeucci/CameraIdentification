function [tprs, fprs, thresholds] = crossvalidateThreshold(imgpath, imgtype, numFolders, numImages, weights, range, type, outputPath, offset)
% Find optimal threshold for normalized cuts algorithm
%
%   INPUTS
%   Required parameters
%
%   weights  : matrix of weights for the grapth
%   range: range of values for searching threshold
%   type: 'NC' or 'AC'
% ----------------------------------------------------
% Authors: Lorenzo Cioni, Saverio Meucci
% ----------------------------------------------------

    filenames = getImagesPath(imgpath, imgtype, 'NumFolders', numFolders, 'NumImages', numImages, 'Offset', offset); 
    n_images = length(filenames);    
    images = cell(n_images, 1);
    
    for i = 1:n_images
        images{i}.name = filenames(i).filename;
        images{i}.folder = filenames(i).camera;
    end
    
    images = cell2mat(images);
        
    fprintf('Crossvalidate threshold value in range\n\n');
    
    thresholds = zeros(length(range), 1);
    fprs = zeros(length(range), 1);
    tprs = zeros(length(range), 1);
    
    for i = 1:length(range)
        th = range(i);
        fprintf('Setting threshold to: %f - ', th);
        clusters = normalizedCuts(weights, 'Type', type, 'Threshold', th, 'Verbose', false);
        [TPR, FPR] = validateClusterResults(images, clusters);
        fprintf('TPR: %f, FPR: %f\n', TPR, FPR);
        thresholds(i) = th;
        fprs(i) = FPR;
        tprs(i) = TPR;
    end   
        
    if ~isempty(outputPath) && ~exist(['mat/' outputPath], 'dir')
        mkdir(['mat/' outputPath]);
    end
    save(['mat/' outputPath 'threshold_crossvalidation' type '.mat'], 'thresholds', 'fprs', 'tprs');
 
end

