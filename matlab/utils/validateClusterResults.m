function [precision, recall, accuracy] = validateClusterResults(images, clusters)
%Evaluate clustering results

    precisions = zeros(length(clusters), 1);
    recalls = zeros(length(clusters), 1);
    accuracies = zeros(length(clusters), 1);
    for i = 1:length(clusters) 
        clust = clusters{i};
        dim = length(clust);
        labels = {images(clust).folder};
        counts = cellfun(@(x) sum(ismember(labels, x)), labels);
        [best, idx] = max(counts);
        total = sum(strcmp(labels(idx), {images.folder}));
        if best ~= dim
            tp = best;
            fp = dim - tp;
        else
            tp = dim;
            fp = 0;
        end  
        fn = total - tp;
        tn = length(images) - dim - fn;
        
        precisions(i) = tp / (tp + fp);
        recalls(i) = tp / (tp + fn);
        accuracies(i) = (tp + tn) / (tp + tn + fp + fn);
    end

    precision = mean(precisions);
    recall = mean(recalls);
    accuracy = mean(accuracies);
end

