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
    fprs = zeros(length(range), 1);
    tprs = zeros(length(range), 1);
    
    for i = 1:length(range)
        th = range(i);
        fprintf('Setting threshold to: %f - ', th);
        clusters = normalizedCuts(weights, 'Type', type, 'Threshold', th, 'Verbose', false);
        [P, R, A, TPR, FPR] = validateClusterResults(images, clusters);
        fprintf('Precision: %f, Recall: %f, Accuracy: %f, TPR: %f, FPR: %f\n', P, R, A, FPR, TPR);
        thresholds(i) = th;
        accuracies(i) = A;
        precisions(i) = P;
        recalls(i) = R;
        fprs(i) = FPR;
        tprs(i) =  TPR;
        
        if P > precision
           precision = P;
           threshold = th;
           fprintf('New best threshold found!\n');
        end
    end
    
    save(['mat/threshold_crossvalidation' type '.mat'], 'thresholds', ...
            'accuracies', 'precisions', 'recalls', 'fprs', 'tprs');
    
    title('Precisions');
    plot(thresholds, precisions);
    
    figure;title('Accuracies');
    plot(thresholds, accuracies);
    figure;title('Recalls');
    plot(thresholds, recalls);

    [FA, I] = sort(fprs);
    TP = tprs(I);
    figure;title('ROC fpr over tpr');
    plot(FA, TP);
 
end

