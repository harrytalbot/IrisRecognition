% IDO finds circle location with Daugman's Alg. called by localise
% centresCol, centresRow - Vectors where matching indexes give the column
%   and row position of a centrepoint.
% img - grayscale double image, gaussian blurred and imfilled
% rmin, rmax - radius bounds for circles
% verbose - flag whether to write to console
% returns centrepoints and radius of circles.

function [centreY, centreX, circleRad] = newIDO(centresY, ...
    centresX, img, rmin, rmax, verbose)

%disp('Starting IDO Search.');

highestPeak = 0;

% hide warnings about peaks
warning('off','signal:findpeaks:largeMinPeakHeight');
[height, width] = size(img);

% preallocate radius value vector
radvals = zeros(1,rmax);

% iterate every centre
for n = 1:length(centresX)
    % iterate radius
    
    radiusMasks = zeros(rmax, width, height);
    [x, y] = meshgrid(1:width, 1:height);
    
    radius = (rmin:rmax);
    
    
    radiusMasks(height, width,20:50) = ((centresX(n)-x).^2 + (centresY(n)-y).^2 > (radius^2)-(0.5*radius)) & ((centresX(n)-x).^2 + (centresY(n)-y).^2 < (radius^2)+(0.5*radius));
    
        radiusMasks(rmin:rmax, width, height) = ((50)^2 + (50)^2 > (radius.^2)-(0.5*radius)) & ((50)^2 + (50)^2 < (radius.^2)+(0.5*radius));
    for radius = rmin:rmax
        % meshgrid of size r x c
        [x, y] = meshgrid(1:width, 1:height);
        % mask a circle with some leeway (given through variation in r^2)
        mask = ((centresX(n)-x).^2 + (centresY(n)-y).^2 > (radius^2)-(0.5*radius)) & ...
            ((centresX(n)-x).^2 + (centresY(n)-y).^2 < (radius^2)+(0.5*radius));
        % get number of 1 pixels by summing up values (0s or 1s)
        maskCoverage = sum(mask(:));
        % array multiplication and averaging
        maskedImage = img.*mask;
        value = sum(maskedImage(:)) / maskCoverage;
        % store normalised value at this radius
        radvals(radius)=value;
    end
    
    % set threshold for finding peaks
    peakThresh = 0.001;
    % get differential
    differences = diff(radvals);
    
    [pks,locs] = findpeaks(differences, 'MinPeakHeight', peakThresh);
    % remove any locs lower than radius min i.e. the first tall spike that
    % is created from where we start searching
    index = find(locs <= rmin); locs(index) = []; pks(index) = [];
    
    % get highest peak for this centre, compare with overall highest
    [peak, radius] = max(pks);
    if peak > highestPeak
        highestPeak = peak;
        centreX = centresY(n);
        centreY = centresX(n);
        circleRad = locs(radius);
    end
end
if verbose
    disp(['Highest peak above ', num2str(peakThresh), ': (', num2str(centreY), ...
        ',' , num2str(centreX) , '), radius ' , num2str(circleRad)]);
end
end

