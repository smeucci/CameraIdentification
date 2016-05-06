function affinity = PCEdistance(imgx, imgy)
%Evaluate the PCE distance between imgx and imgy (both PRNU noises)
    noisex = imgx.PRNU;
    noisey = imgy.PRNU;
    C = crosscorr(noisex, noisey);
    detection = PCE(C);
    affinity = detection.PCE;
end
