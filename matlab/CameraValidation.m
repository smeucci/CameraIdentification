function [camera, affinity] = CameraValidation(image)
%CAMERAVALIDATION Summary of this function goes here
%   Detailed explanation goes here

    addpath('utils');
    addpath('Functions');
    addpath('Filter');
    addpath('rwt-master/bin');
    
    fprintf('CameraValidation for image %s\n', image);

    camera_folder = dir('mat/cameras/');
    n_cameras = length(camera_folder) - 2;
    
    fprintf('\nFound %d cameras\n', n_cameras);
    fprintf('\nSearch for best camera PRNU match...\n');
     
    counter = 0;
    start_time = clock;
    
    fprintf('Camera processed: 0 / 0.00 %% - Elapsed time: 0.0 s\n');
    
    pce = zeros(length(n_cameras), 1);
    cameras = cell(length(n_cameras), 1);
    
    for i = 1:n_cameras
       load(['mat/cameras/camera_' num2str(i) '.mat'], 'camera'); 
       height = size(camera.fingerprint, 1);
       width = size(camera.fingerprint, 2);
       
       I = double(rgb2gray(imread(image)));
       %Resize image if different size from fingerprint
       if(size(I, 1) ~= height || size(I, 2) ~= width)
           I = imresize(I, [height width]);
       end  
         
       PRNU = NoiseExtractFromImage(image, 2);
       PRNU = WienerInDFT(PRNU, std2(PRNU));
       
       %Resize prnu if different size from fingerprint
       if(size(PRNU, 1) ~= height || size(PRNU, 2) ~= width)
           PRNU = imresize(PRNU, [height width]);
       end  
       
       C = crosscorr(PRNU, I .* camera.fingerprint);
       detection = PCE(C);
       pce(i) = detection.PCE;
       cameras{i}.pce = pce(i);
       cameras{i}.folder = camera.folder;
       counter = counter + 1;
       fprintf('Camera processed: %d / %.2f %%', counter, ...
                   (counter * 100/n_cameras));
       fprintf(' - Elapsed time: %.2f s\n', etime(clock, start_time));
    end
    
    [affinity, index] = max(pce);
    camera = cameras{index}.folder;
    
end

