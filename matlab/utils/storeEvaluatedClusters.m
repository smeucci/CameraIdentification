function storeEvaluatedClusters(images, clusters)
%Display evaluated class in table
    
    labels = cell(length(images), 1);
    for i = 1:length(clusters)
        clust = clusters{i};
        for j = 1:length(clust)
           labels{clust(j)} = i;     
        end     
    end

    T = table({images.name}', labels, ...
        'VariableNames', {'Image', 'Cluster'});
    
    writetable(T, 'clusters.txt', 'Delimiter',' ')
    
end

