function [FA,log10FA] = temp_FAfromPCE(pce,search_space)
% Calculates false alarm probability from having peak-to-cross-correlation (PCE) measure of the peak
% pce           PCE measure obtained from PCE.m
% seach_space   number of correlation samples from which the maximum is taken
%  USAGE:   FA = FAfromPCE(31.5,32*32);

% p = 1/2*erfc(sqrt(pce)/sqrt(2));
[p,logp] = Qfunction(sign(pce)*sqrt(abs(pce)));
if pce<50, 
    FA = 1-(1-p).^search_space;
else
    FA = search_space*p;                % an approximation
end

if FA==0,
    FA = search_space*p;   
    log10FA = log10(search_space)+logp*log10(2);
else 
    log10FA = log10(FA);
end    
end

function [Q,logQ] = Qfunction(x)
% Calculates probability of a Gaussian variable N(0,1) taking value larger than x

if x<37.5, 
    Q = 1/2*erfc(x/sqrt(2));
    logQ = log(Q);
else
    Q = 1./sqrt(2*pi)./x.*exp(-(x.^2)/2);
    logQ = -(x.^2)/2 - log(x)-1/2*log(2*pi);
end
end