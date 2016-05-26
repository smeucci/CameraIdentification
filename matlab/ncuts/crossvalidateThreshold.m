function [threshold, precision] = crossvalidateThreshold(imgpath, numFolders, numImages, weights, range, type)
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

    filenames = getImagesPath(imgpath, 'imgs_nat', 'NumFolders', numFolders, 'NumImages', numImages); 
    n_images = length(filenames);    
    images = cell(n_images, 1);
    
    for i = 1:n_images
        images{i}.name = filenames(i).filename;
        images{i}.folder = filenames(i).camera;
    end
    
    images = cell2mat(images);
    
    precision = 0;
    %Default value
    threshold = 10^-4;
    
    fprintf('Crossvalidate threshold value in range\n\n');
    
    thresholds = zeros(length(range), 1);
    accuracies = zeros(length(range), 1);
    precisions = zeros(length(range), 1);
    recalls = zeros(length(range), 1);
    
    for i = 1:length(range)
        th = range(i);
        fprintf('Setting threshold to: %f - ', th);
        clusters = normalizedCuts(weights, 'Type', type, 'Threshold', th, 'Verbose', false);
        [P, R, A] = validateClusterResults(images, clusters);
        fprintf('Precision: %f, Recall: %f, Accuracy: %f\n', P, R, A);
        thresholds(i) = th;
        accuracies(i) = A;
        precisions(i) = P;
        recalls(i) = R;
        if P > precision
           precision = P;
           threshold = th;
           fprintf('New best threshold found!\n');
        end
    end
    
    save(['mat/threshold_crossvalidation' type '.mat'], 'thresholds', 'accuracies', 'precisions', 'recalls');
    plot(thresholds, precisions);
    plot(thresholds, accuracies);
    plot(thresholds, recalls);

end

