function [degree] = getDegreeMatrix(weights)
%GETDEGREEMATRIX Summary of this function goes here
%   Detailed explanation goes here

    degree = zeros(size(weights, 1), size(weights, 2));
    s = sum(weights, 1);
    for i = 1:size(weights, 1)
        degree(i, i) = s(i);
    end

end

