function [output] = CameraIdentification(imgpath, type, n, varargin)
% Camera images clustering for camera identification
%
%   INPUTS
%   Required parameters
%
%   imgpath  : path of reference images
%   type     : the types of the images (name of the folder)
%   n        : the number of images to be taken from each folder
%   
%   Optional parameters (key, value)
%   
%   'ExtractNoise' : true/false if noise from images must be extracted
%                    (default true)
%   'Threads'      : number of threads to be used (default 1)
%
%   USAGE  output = CameraIdentification(imgpath, 'imgs', 3,
%               'ExtractNoise', true, 'Threads', 4)
%
%   OUTPUT
%   clustering matrix (?)
% ----------------------------------------------------
% Authors: Lorenzo Cioni, Saverio Meucci
% ----------------------------------------------------

    p = inputParser;
    p.KeepUnmatched = true;
    defaultExtract = true;
    defaultThreads = 1;
    checkThread = @(x) (x >= 1);

    addOptional(p,'ExtractNoise', defaultExtract, @(x) islogical(x));
    addOptional(p,'Threads', defaultThreads, checkThread);
    
    parse(p, varargin{:});
    extract_noise = p.Results.ExtractNoise;
    threads = p.Results.Threads;
    
    fprintf('Camera Identification\n');
    fprintf('  -Dataset path: %s\n', imgpath); 
    fprintf('  -Type: %s\n', type); 
    fprintf('  -Number of images per folder: %d\n', n);
    fprintf('  -Extract noise: %d\n', extract_noise);
    fprintf('  -Threads: %d\n', threads);

    addpath('utils');
    addpath('Functions');
    addpath('Filter');
    addpath('rwt-master/bin');
    
    %Constants mat filenames
    mat_images_noises = 'images_noises.mat';
    mat_images_weights = 'images_weights.mat';
    
    %Read image path looking for images
    filenames = getImagesPath(imgpath, type, n); 
        
    n_images = length(filenames);
        
    fprintf('\nExtracting PRNU noise from %d images\n\n', n_images);
    
    images = cell(n_images, 1);
   
    width = 0;
    height = 0;
    
    %% Noise extraction
    
    if extract_noise || ~(exist(['mat/' mat_images_noises], 'file') == 2)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Multithread noise extraction %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if threads > 1
            %Check if there are pools opened
            pool = gcp('nocreate');
            if isempty(pool)
                parpool('local', threads);
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
        save(['mat/' mat_images_noises], 'images');
    else 
        load(['mat/' mat_images_noises]);
        fprintf('Images noises loaded from file.\n');
    end
    
    
    %% Evaluating weights
    
    if ~(exist(['mat/' mat_images_weights], 'file') == 2)
        %Evaluating weights with PCE distance bewtee noises
        fprintf('\nEvaluating pairwise affinities between noises\n\n');
        start_time = clock;
        weights = zeros(n_images, n_images);
        %Build a triupper matrix of affinities
        counter = 0;
        total_weights = (n_images^2)/2;
        for i = 1:n_images
            for j = i:n_images
                weights(i, j) = PCEdistance(images(i), images(j));
                weights(j, i) = weights(i, j);
                counter = counter + 1;
                fprintf('Weights evaluated: %d / %.2f %%\r', counter, ...
                       (counter * 100/total_weights));
            end
        end
        save(['mat/' mat_images_weights], 'weights');
        fprintf('\nBuilding weights matrix total time: %.2f s\n', etime(clock, start_time));
    else
        load(['mat/' mat_images_weights]);
        fprintf('\nWeights matrix loaded from file.');
    end
     
    %Starts normalized cuts algorithm
    %To be implemented
    %normalizedCuts(weights); 
    
end