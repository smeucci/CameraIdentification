function [camera, affinity] = CameraValidation(image)
%CAMERAVALIDATION Summary of this function goes here
%   Detailed explanation goes here

    addpath('utils');
    addpath('Functions');
    addpath('Filter');
    addpath('rwt-master/bin');
    
    fprintf('  - Image %s\n', image);

    camera_folder = dir('mat/cameras/');
    n_cameras = length(camera_folder) - 2;

    pce = zeros(length(n_cameras), 1);
    cameras = cell(length(n_cameras), 1);
    
    I = double(rgb2gray(imread(image)));
    %Resize image if different size from fingerprint
    
         
    PRNU = NoiseExtractFromImage(image, 2);
    PRNU = WienerInDFT(PRNU, std2(PRNU));
    
    for i = 1:n_cameras
       load(['mat/cameras/camera_' num2str(i) '.mat'], 'camera'); 
       height = size(camera.fingerprint, 1);
       width = size(camera.fingerprint, 2);
       
       tmpImg = I;
       tmpPRNU = PRNU;
       
       if(size(I, 1) ~= height || size(I, 2) ~= width)
           tmpImg = imresize(I, [height width]);
       end  
       
       %Resize prnu if different size from fingerprint
       if(size(PRNU, 1) ~= height || size(PRNU, 2) ~= width)
           tmpPRNU = imresize(PRNU, [height width]);
       end  
       
       C = crosscorr(tmpPRNU, tmpImg .* camera.fingerprint);
       detection = PCE(C);
       pce(i) = detection.PCE;
       cameras{i}.pce = pce(i);
       cameras{i}.folder = camera.folder;
       fprintf('    -Compared with camera: %d\n', i);
    end
    
    cameras = cell2mat(cameras);
    [affinity, index] = max(pce);
    camera = cameras(index).folder;
    
end

