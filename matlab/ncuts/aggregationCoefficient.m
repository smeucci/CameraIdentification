function [value] = aggregationCoefficient(weights)
%AGGREGATIONCOEFFICIENT Summary of this function goes here
%   Detailed explanation goes here

    max_value = max(max(weights));
    min_value = min(min(weights));

    weights = remap(weights, [min_value, max_value], [0, 1]);
    value = sum(sum(weights)) / size(weights, 1);

end

