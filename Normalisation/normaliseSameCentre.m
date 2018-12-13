
% imshow centre is 159 119, pupil rad 31, iris rad 78
function normalisediris = normaliseSameCentre(img, centreCol, centreRow, radPupil, radIris)

if ~ismatrix(img)
    % convert to grayscale if more than 2 dimensions (i.e. has channels)
    img = rgb2gray(img);
end


imgHeight = radIris - radPupil+1;
normalisediris = zeros(imgHeight, 360);

figure();
% loop polar coords
for theta = 1:360
    for r = radPupil:radIris

        colPos = centreCol + ceil(r * cosd(theta));
        rowPos = centreRow + ceil(r * sind(theta));
        % get value at (r, theta)
       
        val = img(colPos,rowPos);
        
        normalisediris(r-radPupil+1, theta) = val;
       % imshow(normalisediris);
    end
end
