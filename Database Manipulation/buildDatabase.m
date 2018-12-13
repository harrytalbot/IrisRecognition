function buildDatabase(rootFolder, buildFolder)

% start and end subject IDs, how many images per subject
idStart = 1; idEnd = 249; imagesPerEye = 13;

method = 'ido';
verbose = 0;
wavelength = 6; orientation = 0;
normalisedHeight = 32; normalisedWidth = 256;
crop = 20;

for identifier = idStart:idEnd % there are max 249 subjects
    for LR = ['L', 'R'] % two eyes
        % make a directory for this eye
        paddedID = sprintf('%03d',identifier);
        
        % if the dir doesn't exist in root, continue
        dir = fullfile(rootFolder, num2str(paddedID), LR);
        if ~(exist(dir, 'dir'))
            continue;
        end
        % if the dir doesn't exist in build, build it
        dir = fullfile(buildFolder, num2str(paddedID), LR);
        if ~(exist(dir, 'dir'))
            mkdir(dir);
        end
        
        % loop every possible eye
        for firstEye = 1:imagesPerEye % there are max 11 images
            % pad with leading 0s if neccesary
            paddedEye = sprintf('%02d',firstEye);
            
            % Create an image filename for eye
            name = strcat('S1', num2str(paddedID), LR, num2str(paddedEye));
            nameWithExt = strcat(name,  '.jpg');
            
            eyeFile = fullfile(rootFolder, num2str(paddedID), LR, nameWithExt);
            
            checkFile = fullfile(buildFolder, num2str(paddedID), LR, [name, '_6_0_c.jpg']);
            % if the original eye image exists in the root folder
            if exist(eyeFile, 'file')
                
                % and it hasn't already been encoded in the build folder
                if exist(checkFile, 'file')
                    continue;
                end
                
                % read in image
                img = im2double(imread(eyeFile));
                % make a copy
                originalImg = img;
                if ~ismatrix(img)
                    % convert to grayscale if more than 2 dimensions (i.e. has channels)
                    img = rgb2gray(img);
                end               
                
                % find boundries
                [pupilRow, pupilCol, pupilRad, irisRow, irisCol, irisRad] = localise(img, method, verbose);
                
                % get a csv file to write to params file
                params = [firstEye, pupilRow, pupilCol, pupilRad, irisRow, irisCol, irisRad];
                params = sprintf('%.0f,',params);
                params = params(1:end-1);
                
                delete([dir '\params.csv']);
                
                % write the params to file
                writeParams(params, dir);        
                
                % normalise - for the database we want a normalised image
                % with no NaN bits, but the method needs NaN bits in the
                % image (e.g. from cropping) to generate the mask. so call
                % it twice. Once with the original image to get the
                % normalised Image
                [normalisedIris, ~] = normalise(originalImg, pupilRow, pupilCol, pupilRad, irisRow, irisCol, ...
                    irisRad, normalisedHeight, normalisedWidth, verbose);
                % and once with a cropped image
                img((1:irisRow-irisRad+crop),1:end) = NaN;
                img((irisRow+irisRad-crop:end),1:end) = NaN;
                [~, occludedNoise] = normalise(img, pupilRow, pupilCol, pupilRad, irisRow, irisCol, ...
                    irisRad, normalisedHeight, normalisedWidth, verbose);
                
                % encode
                [featureVector, noiseVector] = wavelet2DExtract(normalisedIris, occludedNoise, wavelength, orientation);
                
                % save images to file (original, normalised, mask, code)
                
                %imwrite(origImg, fullfile(buildFolder, [name, '.jpg'], 'jpg'));
                
                nameWithDetails = [name, '_' , num2str(wavelength), '_', num2str(orientation)];
                waveDetails = ['_' , num2str(wavelength), '_', num2str(orientation)];
                normDetails = ['_' , num2str(normalisedHeight), '_', num2str(normalisedWidth)];
                
                imwrite(normalisedIris, fullfile(dir, [name, normDetails '_n.jpg']), 'jpg');
                imwrite(noiseVector, fullfile(dir, [name, normDetails, '_m.jpg']), 'jpg');
                imwrite(featureVector, fullfile(dir, [name, waveDetails, '_c.jpg']), 'jpg');
                
                %temp : remove old images
                
                
                if exist(fullfile(dir, [name, '_m.jpg']), 'file')
                    % delete the old mask
                    delete(fullfile(dir, [name, '_m.jpg']));
                    % delete the old normalised
                    delete(fullfile(dir, [name, '_n.jpg']));
                    % delete the old vector
                    delete(fullfile(dir, [name, '_v.jpg']));
                end
                
            end
        end
    end
end
end

% method to control whether to write to console or results CSV
function writeOutput(line, location)
if (strcmp(location,'console'))
    disp(line);
elseif (strcmp(location,'GUI'))
    length = size(app.Console.Value, 1);
    app.Console.Value{length+1,1} = 'Encoding...';
end
end

function writeParams(line, location)
% open file for appending
dbFile = fopen([location, '\params.csv'],'a');
% add a newline char
line = ([line, '\n']);
% write
fprintf(dbFile, line);
% close file
fclose(dbFile);
end
