function [precision, recall, accuracy, fpr, tpr] = validateClusterResults(images, clusters)
%Evaluate clustering results

    precisions = zeros(length(clusters), 1);
    recalls = zeros(length(clusters), 1);
    accuracies = zeros(length(clusters), 1);
    tprs = zeros(length(clusters), 1);
    fprs = zeros(length(clusters), 1);    
    
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
        tn = length(images) - tp - fn;

        %Storing measures
        precisions(i) = tp / (tp + fp);
        recalls(i) = tp / (tp + fn);
        accuracies(i) = (tp + tn) / (tp + tn + fp + fn);
        
        tprs(i) = tp;
        fprs(i) = fp;
        
    end
    
    %Means of precisions, recalls and accuracies of each cluster
    precision = mean(precisions);
    recall = mean(recalls);
    accuracy = mean(accuracies);
    
    tpr = sum(tprs) / length(images);
    fpr = sum(fprs) / length(images);
end

