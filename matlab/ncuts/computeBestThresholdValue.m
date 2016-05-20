function [threshold] = computeBestThresholdValue(weights, degree, eigenvector)
%COMPUTEBESTTHRESHOLDVALUE Summary of this function goes here
%   Detailed explanation goes here

    min_value = Inf;
    for i = 1:size(eigenvector, 1)
        
        value = Ncut(weights, degree, eigenvector, eigenvector(i));
        if value < min_value
           min_value = value;
           threshold = eigenvector(i);
        end
        
    end

end
