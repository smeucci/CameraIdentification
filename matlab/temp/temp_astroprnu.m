path_calibr1 = '/Volumes/Macintosh HD/tmp_PCM/PRNU_DATASET/apple_iphone_4s_id01_calibration/';
path_calibr2 = '/Volumes/Macintosh HD/tmp_PCM/PRNU_DATASET/apple_iphone_4s_id02_calibration/';
addpath(path_calibr1)
addpath(path_calibr2)
[fingerprint1] = PRNUtraining(path_calibr1);
[fingerprint2] = PRNUtraining(path_calibr2);

orig_path='/Users/massimoiuliani/Desktop/astroprnu/orig/';
Img1or = 'IMG_0667orig1.JPG';
Img2or = 'IMG_0358orig2.JPG';
out_path = '/Users/massimoiuliani/Desktop/astroprnu/prnu_changed/';
[pce1or] = PRNUtest(fingerprint1,orig_path);
[pce2or] = PRNUtest(fingerprint2,orig_path);
Img1 = imread(strcat(orig_path,Img1or));
Img2 = imread(strcat(orig_path,Img2or));

%alpha = [0 0.5 : 0.1 : 1];
alpha = [0 0.65];
ll = length(alpha);
for i = 1:ll
Img1mod = zeros(size(Img1));
Img1mod(:,:,1) = double(Img1(:,:,1)) + alpha(i) * fingerprint2 - alpha(i) * fingerprint1;
Img1mod(:,:,2) = double(Img1(:,:,2)) + alpha(i) * fingerprint2 - alpha(i) * fingerprint1;
Img1mod(:,:,3) = double(Img1(:,:,3)) + alpha(i) * fingerprint2 - alpha(i) * fingerprint1;
Img2mod = zeros(size(Img2));
Img2mod(:,:,1) = double(Img2(:,:,1)) + alpha(i) * fingerprint1 - alpha(i) * fingerprint2;
Img2mod(:,:,2) = double(Img2(:,:,2)) + alpha(i) * fingerprint1 - alpha(i) * fingerprint2;
Img2mod(:,:,3) = double(Img2(:,:,3)) + alpha(i) * fingerprint1 - alpha(i) * fingerprint2;
Img1mod = uint8(Img1mod);
Img2mod = uint8(Img2mod);
imwrite(Img1mod,strcat(out_path,'IMG_0667mod1.JPG'),'JPG','Quality',96);
imwrite(Img2mod,strcat(out_path,'IMG_0358mod2.JPG'),'JPG','Quality',96);
[pce1mod(:,i)] = PRNUtest(fingerprint1,out_path);
[pce2mod(:,i)] = PRNUtest(fingerprint2,out_path);
end