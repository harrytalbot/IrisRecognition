
% r & theta are height and width to give polar co-ords
function [code, mask] = wavelet2DExtract(normalisedIris, noise, wavelength, orientation)

%figure(); imshow(normalisedIris), title('Normalised');

% Gabor Parameters. filter frequency should be average ridge frequency

% Apply filter. only interested in the phase information
[~, phase] = imgaborfilt(normalisedIris, gabor(wavelength, orientation));
% imshow(phase);

[height, width] = size(phase);
code = zeros(height, 2*width);

for r = 1:height
    for s = 1:width
        phaseElement = phase(r,s);
        % phase between 0 and 45 degrees clockwise (NE)
        if ((phaseElement > 0) && (phaseElement < (pi/2)))
            code(r,(2*s-1:2*s)) = [1,1];
            % phase between 45 and 90 degrees clockwise (SE)
        elseif ((phaseElement > (pi/2)) && (phaseElement < pi))
            code(r,(2*s-1:2*s)) = [1,0];
            % phase between 90 and 135 degrees clockwise (SW)
        elseif ((phaseElement > -pi) && (phaseElement < -pi/2))
            code(r,(2*s-1:2*s)) = [0,0];
            % phase between 135 and 180 degrees clockwise (NW)
        elseif ((phaseElement > -pi/2) && phaseElement < 0)
            code(r,(2*s-1:2*s)) = [0,1];
        end
    end
end

% noise vector is just the noise mask stretched by factor of 2 in width
mask = imresize(noise, [height, 2*width], 'nearest');
%noiseVector = noise;
end



