function [output] = CameraIdentification(imgpath, type, n, threads)
% Camera images clustering for camera identification
%   INPUT
%   imgpath : path of reference images
%
%   OUTPUT
%   clustering matrix (?)
%----------------------------------------------------
% Authors: Lorenzo Cioni, Saverio Meucci
%----------------------------------------------------

    addpath('utils');
    addpath('Functions');
    addpath('Filter');
    addpath('rwt-master/bin');

    %Checks for multithread options
    if nargin < 4
        threads = 0;
    end
    
    %Read image path looking for images
    filenames = getImagesPath(imgpath, type, n); 
        
    n_images = length(filenames);
        
    fprintf('Extracting PRNU noise from %d images\n\n', n_images);
    
    images = cell(n_images, 1);
   
    width = 0;
    height = 0;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Multithread noise extraction %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if threads > 0
        %Check if there are pools opened
        pool = gcp('nocreate');
        if isempty(pool)
            parpool('parallel', threads);
        else
            fprintf('Enabling pool of %d workers\n', pool.NumWorkers);
        end       
        start_time = clock;
        %%%% da trovare un modo per viasulizzare avanzamento, non posso
        %%%% accedere a variabili locali esterne al parfor
        parfor i = 1:n_images
            images{i}.name = filenames{i};
            %Evaluate PRNU for single image
            images{i}.PRNU = NoiseExtractFromImage(filenames{i}, 2);
            %Filtering image noise (clean up)
            images{i}.PRNU = WienerInDFT(images{i}.PRNU, std2(images{i}.PRNU));
        end
        
        %Max width and height (it can't be done inside parfor)
        for j = 1:n_images
            %Update idth and height for further resizing
            if size(images{j}.PRNU, 1) > height
                height = size(images{j}.PRNU, 1);
            end
            if size(images{j}.PRNU, 2) > width
                width = size(images{j}.PRNU, 2);
            end
        end
    else
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Iterative noise extraction %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Processed images counter
        fprintf('Image processed: 0 / 0.00 %% - Elapsed time: 0.0 s\n');
        counter = 0;
        start_time = clock;
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
    end
    

    fprintf('Extracting noise total time: %.2f s\n', etime(clock, start_time));
    
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
    
    %Evaluating weights with PCE distance bewtee noises
    weights = zeros(n_images, n_images);
    for i = 1:n_images
        for j = i+1:n_images
            weights(i, j) = PCEdistance(images(i), images(j));
            weights(j, i) = weights(i, j); 
        end
    end
    
    weights
    
    %Starts normalized cuts algorithm
    %To be implemented
    output = normalizedCuts(weights); 
    
end