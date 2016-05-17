function camera = evaluateClusterFingerprint(images, validation)
%Evaluate fingerprint for images in a certain cluster
    camera = {};
    
    folders = zeros(length(images), 1);
    if validation
        for i = 1:length(images)
            folders(i) = sum(cellfun(@(x) strcmp(x, images(i).folder), {images.folder}));        
        end
    end
    [~, idx] = max(folders);
    camera.folder = images(idx).folder;
    
    RP = getFingerprint(images);
    RP = rgb2gray1(RP);
    sigmaRP = std2(RP);
    camera.fingerprint = WienerInDFT(RP,sigmaRP);
end
    
    

