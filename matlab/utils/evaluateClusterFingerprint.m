function fingerprint = evaluateClusterFingerprint(images)
%Evaluate fingerprint for images in a certain cluster
    RP = getFingerprint(images);
    RP = rgb2gray1(RP);
    sigmaRP = std2(RP);
    fingerprint = WienerInDFT(RP,sigmaRP);
end
    
    

