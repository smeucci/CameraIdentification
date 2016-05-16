function [value] = Ncut(weights, degree, eigenvector, threshold)
%NCUTS Summary of this function goes here
%   Detailed explanation goes here

    x = (eigenvector > threshold);
    x = (2 * x) - 1;
    d = diag(degree);
    k = sum(d(x > 0)) / sum(d);
    b = k / (1 - k);
    y = (1 + x) - b * (1 - x);
    value = (y' * (degree - weights) * y) / ( y' * degree * y );

end