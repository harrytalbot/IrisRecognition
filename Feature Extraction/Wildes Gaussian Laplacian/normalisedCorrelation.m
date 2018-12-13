

function matchVals = normalisedCorrelation(eye1, eye2)

matchVals = [];
blockSize = 8;

for band = 1:4
    
    [rows, cols] = size(eye1{band});
        
    rowDivisions = rows/blockSize;
    colDivisions = cols/blockSize;
    
    eye1Band = eye1{band};
    eye2Band = eye2{band};
    
    values = [];
    
    for rCounter = 1:rowDivisions
        for cCounter = 1:colDivisions
            roi1 = eye1Band(((rCounter-1)*blockSize)+1:rCounter*blockSize, ...
                ((cCounter-1)*blockSize)+1:cCounter*blockSize);
            
            roi2 = eye2Band(((rCounter-1)*blockSize)+1:rCounter*blockSize, ...
                ((cCounter-1)*blockSize)+1:cCounter*blockSize);
            
            c = normxcorr2(roi1, roi2);
            
%             roi1 = roi1 - mean(roi1(:));
%             roi2 = roi2 - mean(roi2(:));
%             
%             mult = roi1 .* roi2;
%             mult = sum(mult(:));
%             
%             sq1 = roi1 .^2; sq2 = roi2 .^2;
%             den = sqrt(sum(sq1(:)) * sum(sq2(:)));
%             
%             c = mult/den;

            values = [values, c(7,7)];
            
        end
    end
    
    %get median of band
    matchVals = [matchVals, median(values, 'omitnan')];
end
