% function to generate a cell array of edge direction histograms using only
% the edge direction

function result = gradientHistogram(img)

% get the gradient direction of the image
[~, gdir] = imgradient(img);
% get absolute value 
gdir = abs(gdir);

blockSize = 8;
[rows, cols] = size(img);
rowDivisions = rows/blockSize;
colDivisions = cols/blockSize;

% preallocate result cell array
result = cell(rowDivisions, colDivisions);

% bins
bins = 0:22.5:180;

for rCounter = 1:rowDivisions
        for cCounter = 1:colDivisions
                        
            % get the area specified by the window
            roi = gdir(((rCounter-1)*blockSize)+1:rCounter*blockSize, ...
                ((cCounter-1)*blockSize)+1:cCounter*blockSize);
            hist = histcounts(roi,bins);

            % add histogram to result
            result{rCounter, cCounter} = hist;
            
        end
end



end