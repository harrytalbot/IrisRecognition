
%EYES is cell of {name, original, normalised, code, mask, pupilRow, pupilcol,
%pupilRad, irisRow, irisCol, irisRad}

% wando is wavelength and orientation e.g. '_2_45'
% res is normalised resolution e.g. '_32_256'
function [EYES, counter] = loadDatabase(rootFolder, wando, res)

% start and end subject IDs, how many images per subject
idStart = 1; idEnd = 249; imagesPerEye = 13;


EYES(70) = struct('name',[], 'original',[], 'normalised',[], 'code',[], ...
    'mask',[], 'pupilRow',[], 'pupilCol',[], 'pupilRad',[], 'irisRow',[], ...
    'irisCol',[], 'irisRad',[]); 
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
                EYES(counter).name = name;
                % store ....ROOT/001/L/S1001L01.jpg - original
                EYES(counter).original = im2double(imread([base, '.jpg']));
                % store ....ROOT/001/L/S1001L01_6_0_n.jpg - normalised
                EYES(counter).normalised = im2double(imread([base, res, '_n.jpg']));
                % store ....ROOT/001/L/S1001L01_6_0_c.jpg - code
                EYES(counter).code = im2double(imread([base, wando, '_c.jpg']));
                % store ....ROOT/001/L/S1001L01_6_0_m.jpg - mask
                EYES(counter).mask = im2double(imread([base, res, '_m.jpg']));
                % get the line of parameters starting with the eye num
                params = allParams(allParams(:,1) == firstEye,:);
                % read in params- pr, pc, prad, ir, ic, irad
                EYES(counter).pupilRow = params(1,2);
                EYES(counter).pupilCol = params(1,3);
                EYES(counter).pupilRad = params(1,4);
                EYES(counter).irisRow = params(1,5);
                EYES(counter).irisCol = params(1,6);
                EYES(counter).irisRad = params(1,7);

            end
        end
    end
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

