function im = detectOrientation(image)
%DETECTORIENTATION Summary of this function goes here
%   Detailed explanation goes here

    im = image;

    if size(image, 1) > size(image, 2)
       im = imrotate(image, 90); 
    end

end