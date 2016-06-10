function [precision, recall, accuracy, fpr, tpr] = validateClusterResults(images, clusters)
%Evaluate clustering results

    tpr = 0;
    fpr = 0;
    precisions = zeros(length(clusters), 1);
    recalls = zeros(length(clusters), 1);
    accuracies = zeros(length(clusters), 1);
    
    total_labels = unique({images.folder});
    for i = 1:length(clusters)
        intersections = zeros(length(total_labels), 1);
        for l = 1:length(total_labels)
            gt_label = find( cellfun(@(x) strcmp(x, total_labels(l)), {images.folder}));
            I = intersect(clusters{i}, gt_label);
            intersections(l) = length(I);
        end
        
        [best, idx] = max(intersections);
        gt_label = find( cellfun(@(x) strcmp(x, total_labels(idx)), {images.folder}));
        dim = length(gt_label);
        
        tp = best;
        fp = length(clusters{i}) - tp;
        fn = dim - tp;
        tn = length(images) - dim - fn;

        %Storing measures
        precisions(l) = tp / (tp + fp);
        recalls(l) = tp / (tp + fn);
        accuracies(l) = (tp + tn) / (tp + tn + fp + fn);
        
        tpr = tpr + tp;
        fpr = fpr + fp;
        
    end
    
    %Means of precisions, recalls and accuracies of each cluster
    precision = mean(precisions);
    recall = mean(recalls);
    accuracy = mean(accuracies);
    
    tpr = tpr / length(images);
    fpr = fpr / length(images);
end

