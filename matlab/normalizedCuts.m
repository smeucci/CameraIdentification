function [U, S, degree] = normalizedCuts(weights)
%Normalized cuts algorithm

    %Compute degree matrix
    degree = zeros(size(weights, 1), size(weights, 2));
    s = sum(weights, 1);
    for i = 1:size(weights, 1)
        degree(i, i) = s(i);
    end

    %Solve the generalized eigenvalues problem
    [U, S] = eigs(degree - weights, degree, 2, 'sm');
    %Take the second smallest eigenvalue
    [s, i] = max(sum(S, 2));
    %Take the eigenvector associated to the second smallest eigenvalue
    u = U(:, i);
    %Temporary; check if the solution found solves the equation
    delta = 10^-15; % precision
    if ((degree - weights) * u) - (s * degree * u) < delta
       fprintf('\nGeneralized eigensystem corretly solved\n'); 
    else
       fprintf('\nGeneralized eigensyste not solved\n');
    end
    
end

