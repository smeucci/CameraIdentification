%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Validation script for camera images    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

imgpath = '../dataset';
n = 1;
type = 'imgs';

filenames = getImagesPath(imgpath, type, n); 
n_images = length(filenames);

predictedLabels = zeros(length(n_images), 1);
trueLabels = zeros(length(n_images), 1);
for i = 1:n_images
    [cam, ~] = CameraValidation(filenames(i).filename);
    predictedLabels(i) = cam;
    trueLabels(i) = filenames(i).camera;
end

save ('mat/labels.mat', 'predictedLabels', 'trueLabels');

load('mat/labels.mat', 'predictedLabels', 'trueLabels');

predictedLabels
trueLabels