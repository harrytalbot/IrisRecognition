function doughnut = toDoughnut(normalised)

[rows, cols] = size(normalised);

imR = zeros(Mr, Nr);
Om = (Mr+1)/2; % co-ordinates of the center of the image
On = (Nr+1)/2;
sx = (Mr-1)/2; % scale factors
sy = (Nr-1)/2;


normalisedCol = 0;

% loop theta
for theta = 1:cols
    for radial = 1:rows
        
        
    normalisedCol = normalisedCol + 1;
    
    radSteps = normalised(:,theta);
       
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
    % as a result these col and row values give positions that lie on the
    % rubber sheet circles at a radius theta.
    
    % write these col and row values to rows an array for their angle
    allCol(:, normalisedCol)= colValues;
    allRow(:, normalisedCol) = rowValues;
    end
    
end

% use interpolation to extract pupil values to a normalised image
[x,y] = meshgrid(1:size(normalised,2),1:size(normalised,1));

doughnut = interp2(x,y,normalised,allCol,allRow);

