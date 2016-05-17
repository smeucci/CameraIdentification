%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Validation script for camera images    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('utils');

imgpath = '../dataset';
n = 3;
type = 'imgs';

images = getImagesPath(imgpath, type, n); 
n_images = length(images);

predictedLabels = cell(length(n_images), 1);
  for i = 1:n_images
      [cam, ~] = CameraValidation(images(i).filename);
      predictedLabels{i} = cam;
  end
  
save('mat/labels.mat', 'predictedLabels');

load('mat/labels.mat', 'predictedLabels');

[confusionMatrix, ~] = plotConfusionMatrix({images.camera}, predictedLabels, true, 'Confusion Matrix');

correctClassified = sum(diag(confusionMatrix));
imageNumber = sum(confusionMatrix(:));
fprintf('Correctly classified images: %d / %d\n', correctClassified, imageNumber);
accuracy = correctClassified/imageNumber;
fprintf('Accuracy: %.2f %%\n', accuracy * 100);
