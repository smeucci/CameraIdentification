function [value] = aggregationCoefficient(weights)
%AGGREGATIONCOEFFICIENT Summary of this function goes here
%   Detailed explanation goes here

    value = sum(sum(weights)) / (size(weights, 1)^2);

end

