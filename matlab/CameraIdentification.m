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
    defaultExtract = false;

    addOptional(p,'ExtractNoise', defaultExtract, @(x) islogical(x));
    
    parse(p, varargin{:});
    extract_noise = p.Results.ExtractNoise;
    
    fprintf('Camera Identification\n');
    fprintf('  -Dataset path: %s\n', imgpath); 
    fprintf('  -Type: %s\n', type); 
    fprintf('  -Number of images per folder: %d\n', n);
    fprintf('  -Extract noise: %d\n', extract_noise);

    addpath('utils');
    addpath('Functions');
    addpath('Filter');
    addpath('rwt-master/bin');
    addpath('ncuts');
    
    %Constants mat filenames
    mat_images_weights = 'images_weights.mat';
    
    %Read image path looking for images
    filenames = getImagesPath(imgpath, type, n); 
        
    n_images = length(filenames);
        
    fprintf('\nExtracting PRNU noise from %d images\n\n', n_images);
    
    images = cell(n_images, 1);
    for i = 1:n_images
        images{i}.name = filenames(i).filename;
        images{i}.camera = i;
    end
    clear filenames;
    
    width = Inf;
    height = Inf;
    minWidthThreshold = 2048;
    minHeightThreshold = 1000;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %           Noise extraction                %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if extract_noise || ~(exist(['mat/' mat_images_weights], 'file') == 2)
        % Iterative noise extraction %
        %Processed images counter
        fprintf('Image processed: 0 / 0.00 %% - Elapsed time: 0.0 s\n');
        counter = 0;
        start_time = clock;
        for i = 1:n_images
            %Evaluate PRNU for single image
            PRNU = NoiseExtractFromImage(images{i}.name, 2);
            %Filtering image noise (clean up)
            PRNU = WienerInDFT(PRNU, std2(PRNU));  
            %Update idth and height for further resizing
            if size(PRNU, 1) < height && size(PRNU, 1) > minHeightThreshold
                height = size(PRNU, 1);
            end
            if size(PRNU, 2) < width && size(PRNU, 2) > minWidthThreshold
                width = size(PRNU, 2);
            end
                
            save(['mat/image_prnu_' num2str(i) '.prnu'], 'PRNU');
            clear PRNU;

            counter = counter + 1;
            fprintf('Image processed: %d / %.2f %%', counter, ...
                   (counter * 100/n_images));
            fprintf(' - Elapsed time: %.2f s\n', etime(clock, start_time));
        end    
    
        fprintf('Extracting noise total time: %.2f s\n', etime(clock, start_time));
  
        %Resizing images to have all the same dimensions
        fprintf('\nResizing noises to %d x %d\n\n', width, height);
        counter = 0;
        for i = 1:n_images
            load(['mat/image_prnu_' num2str(i) '.prnu'], '-mat');
            if(size(PRNU, 1) ~= height || size(PRNU, 2) ~= width)
                PRNU = imresize(PRNU, [height width]);
            end
            save(['mat/image_prnu_' num2str(i) '.prnu'], 'PRNU');
            clear PRNU;
            counter = counter + 1;
            fprintf('Resized %d / %d images \n', counter, n_images);
        end
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %           Evaluating weights              %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if extract_noise || ~(exist(['mat/' mat_images_weights], 'file') == 2)
        %Evaluating weights with PCE distance bewtee noises
        fprintf('\nEvaluating pairwise affinities between noises\n\n');
        start_time = clock;
        weights = zeros(n_images, n_images);
        %Build a triupper matrix of affinities
        counter = 0;
        total_weights = (n_images^2 - n_images)/2 + n_images;
        for i = 1:n_images
            load(['mat/image_prnu_' num2str(i) '.prnu'], '-mat');
            noisex = PRNU;
            clear PRNU;
            for j = i:n_images     
                load(['mat/image_prnu_' num2str(j) '.prnu'], '-mat');
                noisey = PRNU;
                clear PRNU;
                weights(i, j) = PCEdistance(noisex, noisey);
                weights(j, i) = weights(i, j);  
                counter = counter + 1;
                fprintf('Weights evaluated: %d / %.2f %%\r', counter, ...
                       (counter * 100/total_weights));
            end
        end
        save(['mat/' mat_images_weights], 'weights');
        fprintf('Building weights matrix total time: %.2f s\n', etime(clock, start_time));
    else
        load(['mat/' mat_images_weights], 'weights');
        fprintf('Weights matrix loaded from file.\n');
    end
     
    %Starts normalized cuts algorithm
    %To be implemented
    [clusters, ~] = normalizedCuts(weights);
    clear weights;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Saving fingerprints for clustered cameras %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    images = cell2mat(images);   
    n_clusters = length(clusters);
    
    %Grouping clustered images
    for i = 1:n_clusters
        cluster = clusters{i};
        for k = 1:length(cluster)
            images(cluster(k)).camera = i;
        end     
    end
    
    fprintf('\nClustering done. Found %d clusters.\n', n_clusters);
    fprintf('Evaluating camera fingerprints.\n');

    for k = 1:n_clusters
        fprintf('\nExtracting fingerprint for camera %d\n', k);
        start_time = clock;
        idx = cellfun(@(x) isequal(x, k), {images.camera});
        fingerprint = evaluateClusterFingerprint(images(idx)); 
        save(['mat/cameras/camera_fingerprint_' num2str(k) '.mat'], 'fingerprint');
        fprintf('Fingerprint extracted in: %.2f s\n', etime(clock, start_time));
    end    
    
end