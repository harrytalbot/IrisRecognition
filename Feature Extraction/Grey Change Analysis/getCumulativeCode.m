function [horizontalCode, verticalCode] = getCumulativeCode(normalised)

normalisedRows = 30; normalisedCols = 250;
regionRows = 3; regionCols = 10;
groupSize = 5;

% resize the normalised iris to 30 x 250 so the 3 x 10 regions fit and also
% groups of 5 fit
normalised = imresize(normalised, [normalisedRows, normalisedCols]);
% resize for paper's cropping
%normalised(:,376:525) = [];
%normalised(:, 76:225) = [];
%normalisedCols = 300;
representativeRow = 0;
representativeVals = zeros(normalisedRows/regionRows,normalisedCols/regionCols);

% get the representative Values for each region
% for 1:3:28
for rows = 1:regionRows:normalisedRows - regionRows + 1
    representativeRow = representativeRow+1;
    representativeCol = 0;
    % for 1:10:241
    for cols = 1:regionCols:normalisedCols - regionCols + 1
        representativeCol = representativeCol + 1;
        % get the region, average it, and store it at corresponding
        % position in representativeVals
        region = normalised(rows:rows+regionRows-1,cols:cols+regionCols-1);
        average = sum(region(:)) / 30;
        representativeVals(representativeRow, representativeCol) = average;
    end
end

% representativeVals is 10 x 25
s_0 = 0;
% get cumilative S values in HORIZONTAL direction
sRow = 0;
for rows = 1:(normalisedRows/regionRows)
    sRow = sRow + 1;
    sCol = 0;
    for cols = 1:groupSize:(normalisedCols/regionCols)-groupSize+1
        sCol = sCol + 1;
        % get the group of representative vals
        group = representativeVals(rows, cols:cols+groupSize-1);
        avgRepresentative = sum(group) / groupSize;
        % calculate the s values
        s_hori(1) = s_0 + (group(1) - avgRepresentative);
        for i = 2:groupSize
            s_hori(i) = s_hori(i-1) + (group(i) - avgRepresentative);
        end
        % generate the code for horizontal direction
        code = zeros(1,groupSize);
        [~, minIndex] = min(s_hori);
        [~, maxIndex] = max(s_hori);
        
        if (maxIndex > minIndex)
            % upward slope, set enclosing values to 1
            code(minIndex:maxIndex) = 1;
        else
            % downward slope, set enclosing values to 2
            code(maxIndex:minIndex) = 2;
        end
        % store the horizontal code values
        horizontalCode(rows, cols:cols+groupSize-1) = code;
    end
end

% get cumilative S values in VERITCAL direction
sRow = 0;
for rows = 1:groupSize:(normalisedRows/regionRows)-groupSize+1
    sRow = sRow + 1;
    sCol = 0;
    for cols = 1:(normalisedCols/regionCols)
        sCol = sCol + 1;
        % get the group of representative vals
        group = representativeVals(rows:rows+groupSize-1, cols);
        avgRepresentative = sum(group) / groupSize;
        s_vert(1) = s_0 + (group(1) - avgRepresentative);
        for i = 2:groupSize
            s_vert(i) = s_vert(i-1) + (group(i) - avgRepresentative);
        end
        % store the s values
        sVals(sRow,sCol).vert = s_vert;
        
        % generate the code for vertical direction
        code = zeros(1,groupSize);
        [~, minIndex] = min(s_vert);
        [~, maxIndex] = max(s_vert);
        
        if (maxIndex > minIndex)
            % upward slope, set enclosing values to 1
            code(minIndex:maxIndex) = 1;
        else
            % downward slope, set enclosing values to 2
            code(maxIndex:minIndex) = 2;
        end
        % store the vertical code values
        verticalCode(rows:rows+groupSize-1,cols) = code;       
    end
end

end

