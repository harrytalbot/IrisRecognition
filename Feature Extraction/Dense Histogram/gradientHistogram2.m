% function to generate a cell array of edge direction histograms using the
% magnitude of the angle as a weighting factor

function result = gradientHistogram2(img)

% get the gradient direction of the image
[gmag, gdir] = imgradient(img);
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
        gradientROI = gdir(((rCounter-1)*blockSize)+1:rCounter*blockSize, ...
            ((cCounter-1)*blockSize)+1:cCounter*blockSize);
        
        magROI = gmag(((rCounter-1)*blockSize)+1:rCounter*blockSize, ...
            ((cCounter-1)*blockSize)+1:cCounter*blockSize);
        
        
        % loop pixel values
        hist = [];
        
        
        % generate bins
        indicies= intersect(find(gradientROI>=0),find(gradientROI<22.5));
        hist = [hist, sum(magROI(indicies))];
        
        indicies= intersect(find(gradientROI>=22.5),find(gradientROI<45));
        hist = [hist, sum(magROI(indicies))];
        
        indicies= intersect(find(gradientROI>=45),find(gradientROI<67.5));
        hist = [hist, sum(magROI(indicies))];
        
        indicies= intersect(find(gradientROI>=67.5),find(gradientROI<90));
        hist = [hist, sum(magROI(indicies))];
        
        indicies= intersect(find(gradientROI>=90),find(gradientROI<112.5));
        hist = [hist, sum(magROI(indicies))];
        
        indicies= intersect(find(gradientROI>=112.5),find(gradientROI<135));
        hist = [hist, sum(magROI(indicies))];
        
        indicies= intersect(find(gradientROI>=135),find(gradientROI<157.5));
        hist = [hist, sum(magROI(indicies))];
        
        indicies= intersect(find(gradientROI>=157.5),find(gradientROI<=180));
        hist = [hist, sum(magROI(indicies))];
        %   end
        %end
        % add histogram to result
        result{rCounter, cCounter} = hist;
        
    end
end



end