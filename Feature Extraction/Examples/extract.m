function irisCode = extract(normalisedIris)

% creating a filter bank
bank = sg_createfilterbank(size(IrisRubberSheet), 0.6 , 8, 8,'verbose',1);
% filter the image
r = sg_filterwithbank(IrisRubberSheet,bank,'method',1);
% converting to a 3d matrix: Converting response structure returned by 
% sg_filterwithbank to a matrix more suitable for e.g. using with classifiers.
m = sg_resp2samplematrix(r);
% summing the output of the filter
all = sum(m,3);
% getting the real and imaginary parts
Re = real(all);
Im = imag(all);


[rows,cols] = size(normalisedIris)
IrisCodes = zeros(rows, 2*cols); % two bits for each feature point

for r = 1 : rows
    tt = 0;
    for t = 1 : 2:2*cols
        tt = tt + 1;
        % the real part
        if Re(r,tt) >= 0
            IrisCodes(r,t) = 1;
        else
            IrisCodes(r,t) = 0;
        end
        % the imaginary part
        if Im(r,tt) >= 0
            IrisCodes(r,t+1) = 1;
        else
            IrisCodes(r,t+1) = 0
        end
    end
end