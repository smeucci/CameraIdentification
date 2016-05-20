function [segments] = NcutPartitionAggregationCoefficient(I, weights, id, th_recursion, verbose)
%Normalized cuts algorithm using aggregation coefficients as threshold
%value to stop recursion.

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
    
    ac_A = aggregationCoefficient(weights(A, A));
    ac_B = aggregationCoefficient(weights(B, B));
    %Check if recursion must be stopped
    
    segments_A = {I(A)};
    if ac_A < th_recursion
        segments_A = NcutPartitionAggregationCoefficient(I(A), weights(A, A), [id, '-A'], th_recursion, verbose);
    end
    
    segments_B = {I(B)};
    if ac_B < th_recursion
        segments_B = NcutPartitionAggregationCoefficient(I(B), weights(B, B), [id, '-B'], th_recursion, verbose);
    end

    %Concatenate segments and ids
    segments = [segments_A, segments_B];
    
end
