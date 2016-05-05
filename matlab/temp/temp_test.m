s1=size(f1);
s2=size(f1);
for 1 = floor(-s1/2):ceil(s1/2)
    for j = 1:s2

I1 = double(rgb2gray(D1));
I2 = double(rgb2gray(D2));
C12 = crosscorr(f1,I1c.*f2);
detection = PCE(C12);