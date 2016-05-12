function X = double2range(X)
% convert to double ranging from 0 to 255
    datatype = class(X);
    switch datatype,                % convert to [0,255]
        case 'uint8',  X = double(X);
        case 'uint16', X = double(X)/65535*255;  
    end
end

