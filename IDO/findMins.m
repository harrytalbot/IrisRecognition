% findmins uses thresholding to find possible iris centrepoints
% imgin is filled in double img
%
% returns centresCol, centresRow - Vectors where matching
% indexes give the column and row position of a centrepoint.

function [centresRow, centresCol] = findMins(eye, verbose)

% iris min and max
imax = 130; imin = 70;

[height, width] = size(eye);

% use find to create two vectors that together identify pixels
% that are more black than white (0 = black, 1 = white, look
% for values < 0.5 (0.2 reduces centrepoints further)
[centresRow, centresCol] = find(eye < 0.3);

% go through pixels below threshold, remove them if they are
% too close to the border for the pupi
for n = 1:size(centresRow)
    if (centresRow(n) > imin) && (centresRow(n) <= height - imin) && ...
            (centresCol(n) > imin) && (centresCol(n) <= width - imin)
        % check if it is local min in 3x3 by getting neighbours
        neighbours = eye((centresRow(n) - 1):(centresRow(n) + 1), ...
            (centresCol(n) - 1):(centresCol(n) + 1));
        % and then getting min
        localmin = min(neighbours);
        % if not equal to local min, mark as NaN for removal later
        if (eye(centresRow(n),centresCol(n)) ~= localmin)
            centresRow(n) = NaN; centresCol(n) = NaN;
        end
    else
        % mark all pixels from original image that are too close to border
        centresRow(n) = NaN; centresCol(n) = NaN;
    end
end

% remove all NaN
index = find(isnan(centresCol));
centresRow(index) = []; centresCol(index) = [];

% reduce centrepoints using distance from median centrepoints
% get the median centrepoints
medY = median(centresRow); medX = median(centresCol);
% half dimension of square to cut mins from e.g. tol = 10 = 20 x 20
tol = 10;
lowerYThresh = medY-tol; upperYThresh = medY+tol;
lowerXThresh = medX-tol; upperXThresh = medX+tol;
% then restrict size based on median
% find everywhere row is above & below square bounded thresh
yIndex = find(centresRow < lowerYThresh | centresRow > upperYThresh);
centresCol(yIndex) = []; centresRow(yIndex) = [];
% find everywhere col is above & below square bounded thresh
xIndex = find(centresCol < lowerXThresh | centresCol > upperXThresh);
centresCol(xIndex) = []; centresRow(xIndex) = [];

% colour potential points red for display
rgbImage = cat(3, eye, eye, eye);
for g = 1:size(centresRow)
    rgbImage(centresRow(g), centresCol(g), 1) = 255;
    rgbImage(centresRow(g), centresCol(g), 2) = 0;
    rgbImage(centresRow(g), centresCol(g), 3) = 0;
end
if verbose
    disp(['Potential Centres: ', num2str(g)]);
end

%figure(), imshow(rgbImage);%, title('Potential Pupil Centrepoints');

end