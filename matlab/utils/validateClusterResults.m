function [precision, recall, accuracy, fpr] = validateClusterResults(images, clusters)
%Evaluate clustering results

    precisions = zeros(length(clusters), 1);
    recalls = zeros(length(clusters), 1);
    accuracies = zeros(length(clusters), 1);
    fprs = zeros(length(clusters), 1);
    
    total_labels = unique({images.folder});
    for l = 1:length(total_labels)
        gt_label = find( cellfun(@(x) strcmp(x, total_labels(l)), {images.folder}));
        intersections = zeros(length(clusters), 1);
        for i = 1:length(clusters)
            clust = clusters{i};
            I = intersect(clust, gt_label);
            intersections(i) = length(I);
        end
        
        [best, idx] = max(intersections);
        dim = length(clusters{idx});
        if best ~= dim
            tp = best;
            fp = dim - tp;
        else
            tp = dim;
            fp = 0;
        end  
        fn = length(gt_label) - tp;
        tn = length(images) - dim - fn;
        
        %Storing measures
        precisions(l) = tp / (tp + fp);
        recalls(l) = tp / (tp + fn);
        accuracies(l) = (tp + tn) / (tp + tn + fp + fn);
        fprs(l) = fp / (tp + fp);
        
    end

    %Means of precisions, recalls and accuracies of each cluster
    precision = mean(precisions);
    recall = mean(recalls);
    accuracy = mean(accuracies);
    fpr = mean(fprs);
end

