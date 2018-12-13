function buildSizeDatabase(rootFolder, buildFolder)

% start and end subject IDs, how many images per subject
idStart = 1; idEnd = 82; imagesPerEye = 10;

% define localisation method and whether to print output
method = 'ido';
verbose = 0;

% there are max 249 subjects
for identifier = idStart:idEnd
    for LR = ['L', 'R'] % two eyes
        % paddedID = 001
        paddedID = sprintf('%03d',identifier);
        % list of directories
        directories = cell(5:1);
        directories{1} = strcat(buildFolder, '\Sample_Set_16_128\', fullfile(num2str(paddedID), LR));
        %mkdir(directories{1});
        directories{2} = strcat(buildFolder, '\', fullfile(num2str(paddedID), LR));
        mkdir(directories{2});
        directories{3} = strcat(buildFolder, '\Sample_Set_64_512\', fullfile(num2str(paddedID), LR));
        % mkdir(directories{3});
        directories{4} = strcat(buildFolder, '\Sample_Set_16_64\', fullfile(num2str(paddedID), LR));
        % mkdir(directories{4});
        directories{5} = strcat(buildFolder, '\Sample_Set_32_32\', fullfile(num2str(paddedID), LR));
        %mkdir(directories{5});
        
        %loop every eye image for this eye
        for firstEye = 1:imagesPerEye % there are max 11 images
            % pad with leading 0s if neccesary - paddedEye = 01
            paddedEye = sprintf('%02d',firstEye);
            
            % Create an image filename for eye
            %name = S1001L01
            name = strcat('S1', num2str(paddedID), LR, num2str(paddedEye));
            %nameWithExt = S1001L01.jpg
            nameWithExt = strcat(name,  '.jpg');
            eyeFile = fullfile(rootFolder, num2str(paddedID), LR, nameWithExt);
            % if the file exists
            if exist(eyeFile, 'file')
                % read in image
                img = im2double(imread(eyeFile));
                origImg = img;
                if ~ismatrix(img)
                    % convert to grayscale if more than 2 dimensions (i.e. has channels)
                    img = rgb2gray(img);
                end
                
                % find boundries
                [pupilRow, pupilCol, pupilRad, irisRow, irisCol, irisRad] = localise(img, method, verbose);
                
                params = [firstEye, pupilRow, pupilCol, pupilRad, irisRow, irisCol, irisRad];
                params = sprintf('%.0f,',params);
                params = params(1:end-1);
                sizes = zeros(5,2);
                sizes(1,:) = [16,128];
                sizes(2,:) = [32,256];
                sizes(3,:) = [64,512];
                sizes(4,:) = [16,64];
                sizes(5,:) = [32,32];
                
                for sizeCounter = 2
                    
                    % if the file already is there already skip
                    
                    
                    writeParams(params, directories{sizeCounter});
                    
                    normalisedHeight = sizes(sizeCounter, 1); normalisedWidth = sizes(sizeCounter, 2);
                    [normalisedIris, occludedNoise] = normalise(img, pupilRow, pupilCol, pupilRad, irisRow, irisCol, ...
                            irisRad, normalisedHeight, normalisedWidth, verbose);
                    imwrite(origImg, strcat(directories{sizeCounter}, '\', name, '.jpg'), 'jpg');
                    
                    for wavelength = 6
                        for orientation = 0
                            
                            
                            % add feature vector and noise mask to array
                            [featureVector, noiseVector] = wavelet2DExtract(normalisedIris, occludedNoise, wavelength, orientation);
                            % save images to file (original, normalised, mask, vector)
                            nameWithDetails = [name, '_' , num2str(wavelength), '_', num2str(orientation)];
                            imwrite(normalisedIris, strcat(directories{sizeCounter}, '\', nameWithDetails, '_n', '.jpg'), 'jpg');
                            imwrite(noiseVector, strcat(directories{sizeCounter}, '\', nameWithDetails, '_m', '.jpg'), 'jpg');
                            imwrite(featureVector, strcat(directories{sizeCounter}, '\', nameWithDetails, '_c', '.jpg'), 'jpg');
                            
                            %temp : remove old images
                            
                            
                        end
                    end
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

