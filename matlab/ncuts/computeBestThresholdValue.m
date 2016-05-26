function [threshold] = computeBestThresholdValue(weights, degree, eigenvector)
%COMPUTEBESTTHRESHOLDVALUE Summary of this function goes here
%   Detailed explanation goes here

    values = zeros(1, size(eigenvector, 1));
    for i = 1:size(eigenvector, 1)
        values(i) = Ncut(weights, degree, eigenvector, eigenvector(i));        
    end
    
    [~, idx] = min(values);
    threshold = eigenvector(idx);

end
