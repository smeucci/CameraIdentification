function [output] = getImagesPath(dataset_path, type)
%GETIMAGESPATH Summary of this function goes here
%   Detailed explanation goes here

folders = dir(dataset_path);

if (~strcmp(type, 'imgs') && ~strcmp(type, 'imgs_nat') && ~strcmp(type, 'imgs_nat_fb') && ~strcmp(type, 'imgs_nat_fb_highres'))
    error('No matching type "%s" found.', type);
end

images = {};
for i = 1:size(folders, 1)
    
    folder = folders(i);
    if (~strcmp(folder.name, '.') && ~strcmp(folder.name, '..') && folder.isdir)
        
        cameras_path = [dataset_path, '/', folder.name];
        cameras = dir(cameras_path);
        
        for j = 1:size(cameras, 1)
            
            camera = cameras(j);
            if (~strcmp(camera.name, '.') && ~strcmp(camera.name, '..') && camera.isdir)
                
                images_path = [cameras_path, '/', camera.name];
                imgs = dir(images_path);
                images = cat(1, images, imgs);
                
            end
            
        end
        
    end
end

output = images;

end

