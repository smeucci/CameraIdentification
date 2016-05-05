function [pce] = PRNUtest(fingerprint,imgpath)

% PCE extraction from n images placed in imgpath
% 
% The fingerprint is extracted according to Goljan, Fridrich
% http://dde.binghamton.edu/download/camera_fingerprint/
%
%   INPUT
%   fingerprint: PRNU estimated in PRNU_training.m
%   imgpath (optional): path of images to be processed 
%   n (optional): number of images to be processed
%
%   OUTPUT
%   pce: n x 1 vector of PCE

% if no input, standard path
    if nargin < 2
    %imgpath = '/Users/massimoiuliani/CyberShare/Dottorato/matlab/dataset/Nikon';
    imgpath = '/Users/massimoiuliani/CyberShare/Dottorato/matlab/dataset/NoPRNUset';
    end

    addpath(imgpath);
imgs = dir(imgpath);
imgs = imgs(~cellfun(@isempty,regexpi({imgs(:,1).name},'\.(tiff?|jpe?g|png|gif)$')));

% if no input, standard path
    %if nargin < 3
    %imgs = imgs(61:80);  
% size check
        %if n > length(imgs)
        %disp('n bigger than number of images!! Going on taking into account real number of images')
        %length(imgs)
        %imgs = imgs(1:end);
        %else
        %imgs = imgs(1:n);
        %end
    %end    
    n = length(imgs);       
           % Number of the images
if n==0, error('No images of specified type in the directory.'); 
end

pce = zeros(n,1);

for i=1:n
    SeeProgress(i),
    if isstruct(imgs)
        im = imgs(i).name;
    else
        im = imgs{i};
    end

    if nargin == 4
    imwrite(imread(im),'test.jpg','Quality',q);
    im = 'test.jpg';
    end
    
Noisex = NoiseExtractFromImage(im,2);
Noisex = WienerInDFT(Noisex,std2(Noisex));



% The optimal detector (see publication "Large Scale Test of Sensor Fingerprint Camera Identification")
Ix = double(rgb2gray(imread(im)));
C = crosscorr(Noisex,Ix.*fingerprint);
detection = PCE(C);
pce(i) = detection.PCE;
end

if nargin == 4
delete('test.jpg');
end

end

