function [A, B] = bipartition(vector, threshold)
%BIPARTITION Summary of this function goes here
%   Detailed explanation goes here
    
    A = find(vector > threshold);
    B = find(vector <= threshold);

end
