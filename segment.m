% takes a file and localisation method, then extracts and normalises

function [normalisedIris, occludedNoise] = segment(img, method, verbose)

% read in image
img = im2double(imread(img));
if ~ismatrix(img)
    % convert to grayscale if more than 2 dimensions (i.e. has channels)
    img = rgb2gray(img);
end

% find boundries
[pupilRow, pupilCol, pupilRad, irisRow, irisCol, irisRad] = localise(img, method, verbose);

% if the pupil and iris centre too far apart, redo with ido
if ((diff([pupilCol, irisCol]) > 20) || (diff([pupilRow, irisRow]) > 20))
%    [pupilY, pupilX, radPupil, irisY, irisX, radIris] = localise(img, 'ido', verbose);
end

imshow(img);
%set(gcf, 'Position', [100, 100, 600, 400])

%hold on;
viscircles([pupilCol, pupilRow], pupilRad, 'Color', 'b');
viscircles([irisCol, irisRow], irisRad, 'Color', 'b');
%         
% rubber-sheet unwrap
normalisedHeight = 32; normalisedWidth = 256;
[normalisedIris, occludedNoise] = normalise(img, pupilRow, pupilCol, pupilRad, irisRow, irisCol, ...
    irisRad, normalisedHeight, normalisedWidth, verbose);

imshow(normalisedIris);

end
