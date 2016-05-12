function [value] = Ncut(weights, degree, eigenvector, threshold)
%NCUTS Summary of this function goes here
%   Detailed explanation goes here

    %Split the vector eigenvector based on the threshold
    split = eigenvector >= threshold;
    
    %Save index of the two splitted sets
    positive = []; h = 1;
    negative = []; k = 1;
    for i = 1:size(split, 1)
       if split(i) == 0
           positive(h) = i;
           h = h + 1;
       else 
           negative(k) = i;
           k = k + 1;
       end
    end

    %Compute the sum of weights that link one node of A (B) to a generic
    %node of the graph
    assoc_AV = 0; assoc_BV = 0;
    for i = 1:size(split, 1)
        if split(i) == 0
            assoc_AV = assoc_AV + degree(i, i);
        else 
            assoc_BV = assoc_BV + degree(i, i);
        end
    end
    
    %Compute the sum of weights that link one node of A to one node of B
    ncut_AB = 0;
    for i = 1:size(positive, 1)
        idx = positive(i);
        for j = 1:size(negative, 1)
           jdx = negative(j);
            ncut_AB = ncut_AB + weights(idx, jdx);
        end
    end
    
    %Compute the final value of ncut(A,B) based on the passed threshold
    %value
    value = (ncut_AB / assoc_AV) + (ncut_AB / assoc_BV);

end
