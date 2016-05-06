function distances = PCEdistance(imgx, imgy)
%Evaluate the PCE distance between imgx and imgy (both PRNU noises)
    distances = zeros(size(imgy, 1), 1);
    for i = 1:size(imgy, 1)
        noisex = imgx.PRNU;
        noisey = imgy(i).PRNU;
        C = crosscorr(noisex, noisey);
        detection = PCE(C);
        distances(i) = max(0, detection.PCE);     
    end
end

