function affinity = PCEdistance(imgx, imgy)
%Evaluate the PCE distance between imgx and imgy (both PRNU noises)
    
   
    noisex = imgx{1};
    noisey = imgy{1};
    
    
    affinity = 0;
    if(size(noisex, 1) == size(noisey, 1) && size(noisex, 2) == size(noisey, 2))
        C = crosscorr(noisex, noisey);
        detection = PCE(C);
        affinity = detection.PCE;
    end
    
    affinity
    
    
end

