function [segments] = NcutPartition(I, weights, id, th_ncut, verbose)
%Normalized cuts algorithm using ncut value of the bipartition to stop
%recursion.

    if verbose
        fprintf('ID %s: ', id);
        disp(I);
    end

    if length(I) < 2
        segments{1} = I;
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
    
    %Check if recursion must be stopped
    ncut = Ncut(weights, degree, eigenvector, threshold);
    if ncut > th_ncut
        segments{1} = I;
        return;
    end
    
    %Recursion
    segments_A = NcutPartition(I(A), weights(A, A), [id, '-A'], th_ncut, verbose);
    segments_B = NcutPartition(I(B), weights(B, B), [id, '-B'], th_ncut, verbose);

    %Concatenate segments and ids
    segments = [segments_A, segments_B];
    
end
