
% imshow centre is 159 119, pupil rad 31, iris rad 78
function [normalisedIris, occludedNoise] = normaliseWildes(img, pupilY, pupilX, ...
    radPupil, irisY, irisX, radIris, rows, cols, verbose)
if verbose
disp(' '); disp(' --- Normalisation ---');
end

resizeFactor = .6;

% trimming will reduce image size so increase it now so output will match
% param desired size
rows = rows + 2;

% preallocate two arrays that will be used to hold col and row positions of
% points that lie on pupil circles with an angle = index
allCol = zeros(rows-2, cols);
allRow = zeros(rows-2, cols);

if ~ismatrix(img)
    % convert to grayscale if more than 2 dimensions (i.e. has channels)
    img = rgb2gray(img);
end

% calculate displacement of pupil center from the iris center
displacementY = pupilY - irisY;
displacementX = pupilX - irisX;

alpha = (displacementY^2 + displacementX^2); % all nums the same in array

phi = atand(displacementY/displacementX);

if (displacementX == 0 || displacementY == 0) 
    phi = pi/2; 
end

normalisedCol = 0;

% loop theta
for theta = 1:(360/cols):360
    normalisedCol = normalisedCol + 1;

    % get beta for this value of theta
    beta = cosd(pi - phi - theta);
    % get distance between centre of pupil and edge of iris at angle theta
    r = (sqrt(alpha).*beta) + ( sqrt( alpha.*(beta.^2) - (alpha - (radIris^2))));
    % get distance between edge of pupil and edge of iris at angle theta
    r = r - radPupil;
    
    % build a vector from 0 to 1, in radialRes number of steps
    divisions = 0:1/(rows-1):1;
    % mulitply the divisions by the edge to edge distance
    radSteps = r.*divisions;
    % so now radSteps is a step from 0 to radialRes in division many steps
    % add the pupil radius onto these steps to give a vector of steps from
    % pupil edge to iris edge
    radSteps = radSteps + radPupil;
    % remove the outermost steps as these will likely be noise from the
    % image i.e. part of pupil or white part of iris
    radSteps  = radSteps(2:(rows-1));
    
    % multiply by resize Factor
    radSteps = radSteps .* resizeFactor;
    
    % Make cartesian coords in form colValues = pupilCol + (r*cos(theta))
    % and rowValues = pupilrow + (r*sin(theta))
    % First get angle constant
    cosValue = cosd(theta);
    sinValue = sind(theta);
    % multiply every radius step by this constant (colValues and rowValues
    % are then 1 x ~radialRes vectors)
    colValues = radSteps.*cosValue;
    rowValues = radSteps.*sinValue;
    % add on orginal col and row to every col and row value
    colValues = pupilY+colValues;
    rowValues = pupilX-rowValues;
    % as a result these col and row values give positions that lie on the
    % rubber sheet circles at a radius theta.
    
    % write these col and row values to rows an array for their angle
    allCol(:, normalisedCol)= colValues;
    allRow(:, normalisedCol) = rowValues;
    
end

% use interpolation to extract pupil values to a normalised image
[x,y] = meshgrid(1:size(img,2),1:size(img,1));

normalisedIris = interp2(y,x,img,allCol,allRow);

% NaN's need to be masked so create a mask from NaN positions
occludedNoise = zeros(size(normalisedIris));
occludedNoise(find(isnan(normalisedIris))) = 1;

% colour NaNs black for display
normalisedIris(isnan(normalisedIris))=0;

end