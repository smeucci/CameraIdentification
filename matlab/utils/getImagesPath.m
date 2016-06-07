function [images] = getImagesPath(dataset_path, type, varargin)
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

    p = inputParser;
    p.KeepUnmatched = true;
    defaultNumFolder = Inf;
    defaultNumImages = Inf;
    defaultRandom = false;

    addOptional(p, 'NumFolders', defaultNumFolder, @(x) isnumeric(x));
    addOptional(p, 'NumImages', defaultNumImages, @(x) isnumeric(x));
    addOptional(p, 'Random', defaultRandom, @(x) islogical(x));
    
    parse(p, varargin{:});
    numFolders = p.Results.NumFolders;
    numImages = p.Results.NumImages;
    random = p.Results.Random;
    
    folders = dir(dataset_path);

    %Check that the passed type is acceptable, otherwise gives an error.
    if (~strcmp(type, 'imgs') && ~strcmp(type, 'imgs_nat') && ~strcmp(type, 'imgs_nat_fb') && ~strcmp(type, 'imgs_nat_fb_highres'))
        error('No matching type "%s" found.', type);
    end

    images = {};
    index = 1;
    
    numFolders = min(size(folders, 1), numFolders);
    folderCounter = 0;
    i = uint8(1);
    while i <= size(folders, 1) && folderCounter < numFolders
        
        folder = folders(i);
        if (~strcmp(folder.name, '.') && ~strcmp(folder.name, '..') && folder.isdir)

           folderCounter = folderCounter + 1;     
           camera_path = [dataset_path, '/', folder.name, '/', type];
           imgs = dir(camera_path);
           
           idk = 1;
           for k = 1:size(imgs, 1);
              if (strcmp(imgs(k).name(1), '.') || strcmp(imgs(k).name, '..') || imgs(k).isdir)
                 to_del(idk) = k;
                 idk = idk + 1;
              end
           end
           imgs(to_del) = [];

           count = 0; h = 1;
           
           if(~random)
               while count < min(size(imgs, 1) - 1, numImages) && h < size(imgs, 1)
                   img = imgs(h);
                   h = h + 1;
                   if (~strcmp(img.name(1), '.') && ~strcmp(img.name, '..') && ~img.isdir)  
                       img = [camera_path, '/', img.name];
                       images{index}.filename = img;
                       images{index}.camera = folder.name;
                       index = index + 1;
                       count = count + 1;
                   end 

               end
           else
              randomIndeces = randperm(size(imgs, 1));
              randomIndeces = randomIndeces(1:numImages);
              for r = 1:length(randomIndeces)
                  img = imgs(randomIndeces(r)); 
                  img = [camera_path, '/', img.name];
                  images{index}.filename = img;
                  images{index}.camera = folder.name;
                  index = index + 1;
              
              end
           end
           
        end
        
        i = i + 1;
    end
    
    images = cell2mat(images);

end

