function [fingerprint] = PRNUtraining(imgpath,n)

% PRNU fingerprint extraction from n images placed in imgpath
% 
% The fingerprint is extracted according to Goljan, Fridrich
% http://dde.binghamton.edu/download/camera_fingerprint/
%
%   INPUT
%   imgpath (optional): path of reference images for PRNU estimation
%   n (optional): number of images to be processed
%
%   OUTPUT
%   fingerprint: grey-scale estimation of PRNU

% if no input, standard path
    if nargin < 1
    imgpath = '/Users/massimoiuliani/CyberShare/Dottorato/matlab/dataset/Nikon';
    end
    

imgs = dir(imgpath);
imgs = imgs(~cellfun(@isempty,regexpi({imgs(:,1).name},'\.(tiff?|jpe?g|png|gif)$')));

if nargin < 2
        n = length(imgs);
end
    
% size check
    if n > length(imgs)
        disp('n bigger than number of images!! Going on taking into account real number of images')
        length(imgs)
        imgs = imgs(1:end);
    else
        imgs = imgs(1:n);
    end

% fingerprint extraction
RP = getFingerprint(imgs);
RP = rgb2gray1(RP);
    sigmaRP = std2(RP);
fingerprint = WienerInDFT(RP,sigmaRP);

end

