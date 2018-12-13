
% imshow centre is 159 119, pupil rad 31, iris rad 78
function normalisediris = normaliseSlow(img, pupilY, pupilX, ...
    radPupil, irisY, irisX, radIris, radialRes)

if ~ismatrix(img)
    % convert to grayscale if more than 2 dimensions (i.e. has channels)
    img = rgb2gray(img);
end

% calculate displacement of pupil center from the iris center
displacementY = pupilY - irisY;
displacementX = pupilX - irisX;


alpha = (displacementY^2 + displacementX^2); % all nums the same in array

% need to do something for ox = 0
if displacementY == 0
    phi = 90;
else
    phi = atand(displacementX/displacementY);
end


% loop polar coords
for theta = 1:360
    
    beta = cosd(pi - phi - theta);
    
    % get distance between centre of pupil and edge of iris at angle theta
    r = (sqrt(alpha).*beta) + ( sqrt( alpha.*(beta.^2) - (alpha - (radIris^2))));
    % get distance between egde of pupil and edge of iris at angle theta
    r = r - radPupil;
    
    for temp = 1:radialRes
        
        radialDev = 1/(radialRes) * temp;
        newR = radialDev * r;
        newR = newR + radPupil;
        
        c = newR * cosd(theta);
        s = newR * sind(theta);
        yPos = pupilY - round(c);
        xPos = pupilX + round(s);
        
        val = img(xPos,yPos);
        img(xPos,yPos) = 0;
        normalisediris(temp, theta) = val;
    end

end
imshow(normalisediris);