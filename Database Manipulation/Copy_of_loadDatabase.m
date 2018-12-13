
%EYES is cell of {name, original, normalised, code, mask, pupilRow, pupilcol,
%pupilRad, irisRow, irisCol, irisRad}

%wando is wavelength and orientation e.g. '_2_45'
function [EYES, counter] = loadDatabase(rootFolder, wando)

% start and end subject IDs, how many images per subject
idStart = 1; idEnd = 249; imagesPerEye = 13;
% for holding the database
EYES = cell(211, 11);
% for counting the number of eyes
counter = 0;

for identifier = idStart:idEnd % there are max 249 subjects
    for LR = ['L', 'R'] % two eyes
        % pad with leading 0s if neccesary - 001
        paddedID = sprintf('%03d',identifier);
        % check the eye exists
        if ~(exist(fullfile(rootFolder, num2str(paddedID), LR), 'dir'))
            continue;
        end
        % read in params file
        allParams = csvread(fullfile(rootFolder, num2str(paddedID), LR, 'params.csv'));
        % there are max 11 images
        for firstEye = 1:imagesPerEye
            % pad with leading 0s if neccesary - 01
            paddedEye = sprintf('%02d',firstEye);
            % Create an image filename for eye
            % name = S1001L01
            name = ['S1', num2str(paddedID), LR, num2str(paddedEye)];
            % base = ....ROOT/001/L/S1001L01
            base = fullfile(rootFolder, num2str(paddedID), LR, name);
                        
            % check existance of ....ROOT/001/L/S1001L01_6_0_c.jpg
            if exist(strcat(base, wando, '_c.jpg'), 'file')
                counter = counter + 1;
                % store name
                EYES(counter, 1) = {name};
                % store ....ROOT/001/L/S1001L01.jpg - original
                EYES(counter, 3) = {im2double(imread([base, '.jpg']))};
                % store ....ROOT/001/L/S1001L01_6_0_n.jpg - normalised
                EYES(counter, 3) = {im2double(imread([base, wando, '_n.jpg']))};
                % store ....ROOT/001/L/S1001L01_6_0_c.jpg - code
                EYES(counter, 4) = {im2double(imread([base, wando, '_c.jpg']))};
                % store ....ROOT/001/L/S1001L01_6_0_m.jpg - mask
                EYES(counter, 5) = {im2double(imread([base, wando, '_m.jpg']))};
                % get the line of parameters starting with the eye num
                params = allParams(allParams(:,1) == firstEye,:);
                % read in params- pr, pc, prad, ir, ic, irad
                for paramCounter = 1:6  
                    EYES(counter, 5+paramCounter) = {params(paramCounter+1)};
                end
            end
        end
    end
end
end