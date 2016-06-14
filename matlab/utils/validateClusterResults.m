function [tpr, fpr] = validateClusterResults(images, clusters)
%Evaluate clustering results

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
        tprs(i) = tp / (tp + fn);
        fprs(i) = fp / (fp + tn);
        
    end
    
    %TPR and FPR average
    tpr = sum(tprs) / length(total_labels);
    fpr = sum(fprs) / length(total_labels);
end

