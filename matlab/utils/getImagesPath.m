function [images] = getImagesPath(dataset_path, type, num)
%GETIMAGESPATH Summary of this function goes here
%   Detailed explanation goes here

if nargin == 2
    num = Inf;
end

folders = dir(dataset_path);

if (~strcmp(type, 'imgs') && ~strcmp(type, 'imgs_nat') && ~strcmp(type, 'imgs_nat_fb') && ~strcmp(type, 'imgs_nat_fb_highres'))
    error('No matching type "%s" found.', type);
end

images = {};
for i = 1:size(folders, 1)
    
    folder = folders(i);
    if (~strcmp(folder.name, '.') && ~strcmp(folder.name, '..') && folder.isdir)
    
       camera_path = [dataset_path, '/', folder.name, '/', type];
       imgs = dir(camera_path);
       
       count = 0; h = 1;
       while count < min(size(imgs, 1) - 1, num) && h < size(imgs, 1)
          
           img = imgs(h);
           h = h + 1;
           if (~strcmp(img.name(1), '.') && ~strcmp(img.name, '..') && ~img.isdir)
               
               img = [camera_path, '/', img.name];
               images = cat(1, images, img);
               count = count + 1;       
           end 
           
       end
       
    end
    
end

end

