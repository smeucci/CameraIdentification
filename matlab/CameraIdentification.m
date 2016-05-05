function [output] = CameraIdentification(imgpath, folder, n)
% Camera images clustering for camera identification
%
%   INPUT
%   imgpath : path of reference images
%
%   OUTPUT
%   clustering matrix (?)

    addpath('utils');

    %Read image path looking for images
    %imgs = getImagesPath(imgpath, type, n); 
    
    images = dir(imgpath);
    images = images(~cellfun(@isempty,regexpi({images(:,1).name},'\.(tiff?|jpe?g|png|gif)$')));
    
    n_images = min(length(images), n);
    
    %Processed images counter
    counter = 0;
    start_time = clock;
    fprintf('Extracting PRNU noise from %d images\n\n', n_images);
    fprintf('Image processed: 0 / 0.00 %% - Elapsed time: 0.0 s\n');
   
    test = {} 
    for i = 1:n_images
        %Evaluate PRNU for single image
        %images(i).PRNU = NoiseExtractFromImage([imgpath images(i).name], 2);
        test{i} = NoiseExtractFromImage([imgpath images(i).name], 2);
        %Filtering image noise (clean up)
        %images(i).PRNU = WienerInDFT(images(i).PRNU, std2(images(i).PRNU));
        test{i} = WienerInDFT(test{i}, std2(test{i}));
        counter = counter + 1;
        fprintf('Image processed: %d / %.2f %%', counter, ...
            (counter * 100/n_images));
        fprintf(' - Elapsed time: %.2f s\n', etime(clock, start_time));
    end
    
    weights = pdist2(test(1:end), test(1:end), @PCEdistance);
    
    
    
    weights
    
      
end