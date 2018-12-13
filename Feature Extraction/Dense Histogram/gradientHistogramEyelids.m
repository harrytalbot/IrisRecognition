% function to generate a histograms for normalised images using the mask to
% produce NaN elements

function result = gradientHistogramEyelids(img, mask)

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
        
        % check the area from the mask
        maskSum = sum(mask(((rCounter-1)*blockSize)+1:rCounter*blockSize, ...
            ((cCounter-1)*blockSize)+1:cCounter*blockSize));
        maskSum = sum(maskSum);
        % ignore if more than 25% masked
        if (maskSum > 4)
            % set the hist to NaN
            hist = NaN;
        else
            % get the area specified by the window
            roi = gdir(((rCounter-1)*blockSize)+1:rCounter*blockSize, ...
                ((cCounter-1)*blockSize)+1:cCounter*blockSize);
            % generate histogram from the roi. hist will be a 1d vector
            hist = histcounts(roi,bins);
        end
        % add histogram to result
        result{rCounter, cCounter} = hist;        
    end
end



end