function [output] = CameraIdentification(imgpath, type, n)
% Camera images clustering for camera identification
%
%   INPUT
%   imgpath : path of reference images
%
%   OUTPUT
%   clustering matrix (?)

    addpath('utils');
    addpath('Functions');
    addpath('Filter');
    addpath('rwt-master/bin');

    %Read image path looking for images
    filenames = getImagesPath(imgpath, type, n); 
        
    n_images = length(filenames);
    
    %Processed images counter
    counter = 0;
    start_time = clock;
    fprintf('Extracting PRNU noise from %d images\n\n', n_images);
    fprintf('Image processed: 0 / 0.00 %% - Elapsed time: 0.0 s\n');
    
    images = cell(n_images, 1);
   
    width = 0;
    height = 0;
    
    for i = 1:n_images
        images{i}.name = filenames{i};
        %Evaluate PRNU for single image
        images{i}.PRNU = NoiseExtractFromImage(filenames{i}, 2);
        %Filtering image noise (clean up)
        images{i}.PRNU = WienerInDFT(images{i}.PRNU, std2(images{i}.PRNU));
        
        %Update idth and height for further resizing
        if size(images{i}.PRNU, 1) > height
            height = size(images{i}.PRNU, 1);
        end
        if size(images{i}.PRNU, 2) > width
            width = size(images{i}.PRNU, 2);
        end
        
        counter = counter + 1;
        fprintf('Image processed: %d / %.2f %%', counter, ...
            (counter * 100/n_images));
        fprintf(' - Elapsed time: %.2f s\n', etime(clock, start_time));
    end
    
    %Resizing images to have all the same dimensions
    fprintf('\nResizing noises to %d x %d\n\n', width, height);
    counter = 0;
    for i = 1:n_images
        if(size(images{i}.PRNU, 1) ~= height || size(images{i}.PRNU, 2) ~= width)
            images{i}.PRNU = imresize(images{i}.PRNU, [height width]);
        end
        counter = counter + 1;
        fprintf('Resized %d / %d images \n', counter, n_images);
    end
    
    images = cell2mat(images);
    
    tic;
    w = zeros(n_images, n_images);
    for i = 1:n_images
        for j = i+1:n_images
            w(i, j) = PCEdistance(images(i), images(j));
        end
    end
    
    w
    toc;
    
    tic;
    %Evaluate pairwise affinities between noise
    weights = pdist(images, @PCEdistance);
    weights = squareform(weights);
    
    weights
    
    toc;
    
    %Starts normalized cuts algorithm
    normalizedCuts(weights);
    
end