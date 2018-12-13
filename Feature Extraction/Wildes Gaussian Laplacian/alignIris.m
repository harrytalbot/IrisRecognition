% function to take an iris and centre it in a square image

function img = alignIris(img, resolution, irisRow, irisCol, irisRad)



% extra is piel border
extra = 5;
pad = 100;
% pad area around the array in case the iris is too close to edge
img = padarray(img, [pad pad], 1, 'both');
irisRow = irisRow + pad;
irisCol = irisCol + pad;

% get the upper, lower, left and right positions. if they go off the image
% they are set to the image bounds.
irisUpper = irisRow-irisRad - extra;
%if (irisUpper < 1)
%    irisUpper = 1;
%end
irisLower = irisRow+irisRad + extra;
%if (irisLower > rows)
%    irisLower = rows;
%end

irisLeft = irisCol-irisRad - extra;
%if (irisLeft < 1)
%    irisLeft = 1;
%end

irisRight = irisCol+irisRad + extra;
%if (irisRight > cols)
%   irisRight = cols;
%end

% clear area outside iris
[rows, cols] = size(img);
% meshgrid of size r x c
[cols, rows] = meshgrid(1:cols, 1:rows);
circlePixels = (rows - irisRow).^2 ...
    + (cols - irisCol).^2 > (irisRad^2)+(0.5*irisRad);

img(circlePixels) = 1;

% get the area
img = img(irisUpper:irisLower, irisLeft:irisRight);
% resize
img = imresize(img, [resolution resolution]);
end