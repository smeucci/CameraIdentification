function affinity = PCEdistance(noisex, noisey)
%Evaluate the PCE distance between imgx and imgy (both PRNU noises)
    C = crosscorr(noisex, noisey);
    detection = PCE(C);
    affinity = detection.PCE;
end
