function [images] = getImagesPath(dataset_path, type, num)
% Return the images path for a given dataset path. Note that this function is 
% folder structure dependent.
%
%   INPUT
%   dataset_path : path of the dataset
%   type: dependent on the dataset used in this project; refers to the
%         subfolder for each camera used. Possible type are 'imgs', 
%         'imgs_nat', 'imgs_nat_fb', 'imgs_nat_fb_highres'.
%   num: number of paths to return for each camera. If not present
%       return all the paths.
%
%   OUTPUT
%   images: paths of the images selected.
% ----------------------------------------------------
% Authors: Lorenzo Cioni, Saverio Meucci
% ----------------------------------------------------  

    %If argument 'num' is not set, it is equal to inf.
    if nargin == 2
        num = Inf;
    end

    folders = dir(dataset_path);

    %Check that the passed type is acceptable, otherwise gives an error.
    if (~strcmp(type, 'imgs') && ~strcmp(type, 'imgs_nat') && ~strcmp(type, 'imgs_nat_fb') && ~strcmp(type, 'imgs_nat_fb_highres'))
        error('No matching type "%s" found.', type);
    end

    images = {};
    camera = 1;
    index = 1;
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
                   images{index}.filename = img;
                   images{index}.camera = camera;
                   index = index + 1;
                   count = count + 1;
               end 

           end
           
           camera = camera + 1;

        end

    end
    
    images = cell2mat(images);

end

