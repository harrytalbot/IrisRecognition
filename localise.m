
% localisation function performs HOUGH and/or IDO search, or a combination
% that find the pupil with IDO and iris with HOUGH. Called by segmentation.

function [pupilRow, pupilCol, pupilRad, irisRow, irisCol, irisRad] = localise(originalEye, type, verbose)

% fill in holes
filledEye = imcomplement(imfill(imcomplement(originalEye),'holes'));

%set circle search boundries
pupilRadMin = 20; pupilRadMax = 60; % for pupil
irisRadMin = 100; irisRadMax = 130; % for iris

if (strcmp(type,'hough') || strcmp(type,'Hough'))
    if verbose
    disp(' '); disp(' --- Localisation - Hough ---');
    end
    % process the input image
    processedEye = imgaussfilt(filledEye, 3);
    
    % get the pupil parameters
    [pupilRow, pupilCol, pupilRad] = varRadHough(processedEye, ...
        pupilRadMin, pupilRadMax, verbose);
    % get the iris parameters
    [irisRow, irisCol, irisRad] = varRadHough(processedEye, ...
        irisRadMin, irisRadMax, verbose);
    % locatedImg = gcf;
    
elseif (strcmp(type,'ido') || strcmp(type,'IDO'))
       
    % process the input image
    processedEye = im2double(filledEye);
    if verbose
    disp(' '); disp(' --- Finding Minimums ---');
    end
    [centresRow, centresCol] = findMins(processedEye, verbose);
    processedEye = imgaussfilt(processedEye, 2);
    processedEye = histeq(processedEye);
    if verbose
    disp(' '); disp(' --- Localisation - IDO ---');
    end
    
    % get the iris parameters
    [irisRow, irisCol, irisRad] = IDO(centresRow, centresCol, ...
        processedEye, irisRadMin, irisRadMax, verbose);
    
    % get the pupil and iris parameters
    % bounds by daugman
    [pupilRow, pupilCol, pupilRad] = IDO(centresRow, centresCol, ...
        processedEye, pupilRadMin, pupilRadMax, verbose);
        % processedEye, ceil(radIris*0.1), floor(radIris*0.8));
    
    % locatedImg = gcf;
    
elseif strcmp(type,'both')
    
    % run the ido and hough seperately, rseults displayed for both
    localise(file, 'ido');
    localise(file, 'hough');
    
elseif strcmp(type,'comb')
    
    % find pupil using IDO
    [pupilRow, pupilCol, pupilRad, ~, ~, ~, ~] = localise(file, 'ido', verbose);
    % find iris using hough
    [~, ~, ~, irisRow, irisCol, irisRad, ~] = localise(file, 'hough', verbose);
    % show results
    figure(), imshow(originalEye), title('Combination'), hold on;
    viscircles([pupilRow, pupilCol], pupilRad, 'Color', 'b');
    viscircles([irisRow, irisCol], irisRad, 'Color', 'r');
    % return parameters
    % locatedImg = gcf;
    
end