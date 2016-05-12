function [weights_A, weights_B, loc_A, loc_B] = bipartition(weights, split)
%BIPARTITION Summary of this function goes here
%   Detailed explanation goes here
    
    %Save index of the two splitted sets
    loc_A = []; h = 1;
    loc_B = []; k = 1;
    for i = 1:size(split, 1)
       if split(i) == 0
           loc_A(h) = i;
           h = h + 1;
       else 
           loc_B(k) = i;
           k = k + 1;
       end
    end
    
    weights_A = weights(loc_A, loc_A);
    weights_B = weights(loc_B, loc_B);

end
