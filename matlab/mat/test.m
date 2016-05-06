function [w, d] = test(A)

    for i = 1:size(A,1)*size(A,2);
        
        for j = 1:size(A,1)*size(A,2);
            
            w(i, j) = exp(-abs(A(i) - A(j)));
            
        end
        
    end

    s = sum(w, 1);
    for i = 1:size(w, 1)
       d(i, i) = s(i);
    end


end