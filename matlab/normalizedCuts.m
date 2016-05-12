function [eigenvector, eigenvalue, threshold] = normalizedCuts(weights, loc)
%Normalized cuts algorithm

    %Compute degree matrix
    degree = getDegreeMatrix(weights);

    %Solve the generalized eigenvalues problem
    [eigenvectors, eigenvalues] = eigs(degree - weights, degree, 2, 'sm');
    %Take the second smallest eigenvalue
    [eigenvalue, i] = max(sum(eigenvalues, 2));
    %Take the eigenvector associated to the second smallest eigenvalue
    eigenvector = eigenvectors(:, i);
    
    %Temporary; check if the solution found solves the equation
    delta = 10^-15; % precision
    if ((degree - weights) * eigenvector) - (eigenvalue * degree * eigenvector) < delta
       fprintf('\nGeneralized eigensystem corretly solved\n'); 
    else
       fprintf('\nGeneralized eigensyste not solved\n');
    end
    
    %Get best threshold value
    threshold = computeBestThresholdValue(weights, degree, eigenvector);
    
    %Bipartition of the graph
    split = eigenvector >= threshold;
    [weights_A, weights_B, loc_A, loc_B] = bipartition(weights, split);
    
end
