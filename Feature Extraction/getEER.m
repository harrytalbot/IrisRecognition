function EER = getEER (FAR, FRR, bins)

% threshInd is roughly where the crossover occurs AFTER interpolation

% for Haar, = 0.407
threshInd = 4000;
FAR = interp1(1:101,FAR,1:1/100:101 );
FRR = interp1(1:101,FRR,1:1/100:101 );
bins = 0:0.01/100:1;

% for HoG, = 4699
% threshInd = 120;
% FAR = interp1(1:71,FAR,1:1/100:71 );
% FRR = interp1(1:71,FRR,1:1/100:71 );
% bins = 1500:50/100:5000;

% for gabor, = 0.307
% threshInd = 1925;
% FAR = interp1(1:101,FAR,1:1/60:101 );
% FRR = interp1(1:101,FRR,1:1/60:101 );
% bins = 0:0.01/60:1;

% for csumMask, = 0.182
% threshInd = 1200;
% FAR = interp1(1:61,FAR,1:1/60:61 );
% FRR = interp1(1:61,FRR,1:1/60:61 );
% bins = 0:0.01/60:1;

% for csumCrop, = 0.186
% threshInd = 1200;
% FAR = interp1(1:61,FAR,1:1/60:61 );
% FRR = interp1(1:61,FRR,1:1/60:61 );
% bins = 0:0.01/60:1;

% Integrate FAR using trapz.
while(1)
areaFAR = trapz(FAR(1:threshInd));
areaFRR = trapz(FRR(threshInd:end));

if (areaFAR > areaFRR)
    threshInd = threshInd - 1;
else
    threshInd = threshInd + 1;
end

disp(num2str(bins(threshInd)));
end
end