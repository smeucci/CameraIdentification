function [segments, ids] = NcutPartition(I, weights, id, verbose)
%Normalized cuts algorithm

    if verbose
        fprintf('ID %s: ', id);
        disp(I);
    end

    if length(I) < 2
        segments{1} = I;
        ids{1} = id;
        return;
    end

    %Compute degree matrix
    degree = getDegreeMatrix(weights);

    %Solve the generalized eigenvalues problem
    [eigenvectors, eigenvalues] = eigs(degree - weights, degree, 2, 'sm');
    %Take the second smallest eigenvalue
    [eigenvalue, i] = max(abs(sum(eigenvalues, 2)));
    %Take the eigenvector associated to the second smallest eigenvalue
    eigenvector = eigenvectors(:, i);
    
    %Get best threshold value
    threshold = computeBestThresholdValue(weights, degree, eigenvector);
    
    %Bipartition of the graph
    [A, B] = bipartition(eigenvector, threshold);
    
    %Check if recursion must be stopped: size of partition too small or
    %ncut value for current partition smaller than a threshold ncut value
    ncut = Ncut(weights, degree, eigenvector, threshold);
    if ncut > 10^-4
        %Assign images to returned clusters
        segments{1} = I;
        ids{1} = id;
        return;
    end    
    
    %Recursion
    [segments_A, id_A] = NcutPartition( I(A), weights(A, A), [id, '-A'], verbose);
    [segments_B, id_B] = NcutPartition( I(B), weights(B, B), [id, '-B'], verbose);

    %Concatenate segments and ids
    segments = [segments_A, segments_B];
    ids = [id_A, id_B];
    
end
