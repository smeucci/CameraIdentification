function [output] = CameraIdentification(imgpath)
% Camera images clustering for camera identification
%
%   INPUT
%   imgpath : path of reference images
%
%   OUTPUT
%   clustering matrix (?)

    %Read image path looking for images
    imgs = dir(imgpath);
    imgs = imgs(~cellfun(@isempty,regexpi({imgs(:,1).name},'\.(tiff?|jpe?g|png|gif)$')));
    
    for i = 1:length(imgs)
       imgs(i).pnru = NoiseExtractFromImage([imgpath imgs(i).name], 2);
       disp(imgs(i));
    end


end