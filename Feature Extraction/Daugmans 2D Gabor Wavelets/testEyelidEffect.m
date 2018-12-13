
% function comparing an eye with various levels of occlusion to eyes with
% no occlusion

function allAcceptanceRate = testEyelidEffect(EYES, numberOfEntries)

threshold = .33;

problemMatch = zeros(numberOfEntries, 1);
problemSubject = zeros(numberOfEntries, 1);

allAcceptanceRate = [];

% crop is the number of pixels the iris will be occluded
for crop = 1:5:61
    correctAcceptance = 0; correctRejection = 0;
    incorrectAcceptance = 0; incorrectRejection = 0;
    
    % go over every entry as the subject eye
    for counter = 1:numberOfEntries
        % get the original eye
        name = EYES(counter).name;
        %disp(name);
        original = EYES(counter).original;
        irisRow = EYES(counter).irisRow;
        irisRad = EYES(counter).irisRad;        
        % apply this level of occlusion from the top down
        % original((irisRow-irisRad:irisRow-irisRad+crop),1:end) = NaN;
        original((irisRow+irisRad-crop:irisRow+irisRad),1:end) = NaN;
        imshow(original);
        %viscircles([irisCol, irisRow], irisRad, 'Color', 'b');
        % normalise it
        normalisedHeight = 32; normalisedWidth = 256;
        [normalisedIris, occludedNoise] = normalise(original, ...
            EYES(counter).pupilRow, EYES(counter).pupilCol, EYES(counter).pupilRad, ...
            EYES(counter).irisRow, EYES(counter).irisCol, EYES(counter).irisRad, ...
            normalisedHeight, normalisedWidth, 0);
        
        % encode it
        [code, mask] = wavelet2DExtract(normalisedIris, occludedNoise, 6, 0);
        % mask = zeros(32,512);
        % we will now compare this entry with the rest of the set.       
        dist = 1;        
        for queryCounter = 1:numberOfEntries
            % leave one out strategy so skip if same (hd = 0)
            if (queryCounter == counter)
                continue;
            end
            % get the parts to compare with 
            codeQuery = EYES(queryCounter).code;
            maskQuery = EYES(queryCounter).mask;
            % get the distance
            thisDist = getHammingDist(code, mask, codeQuery, maskQuery);
            % if new lowest distance, set as best match
            if (thisDist < dist)
                matchName = EYES(queryCounter).name;
                dist = thisDist;
            end
        end
        
        % check if correct and update the values
        if ((dist < threshold) && strcmp(name(1:5), matchName(1:5)))
            correctAcceptance = correctAcceptance + 1;
        elseif ((dist > threshold) && ~strcmp(name(1:5), matchName(1:5)))
            correctRejection = correctRejection + 1;
        elseif ((dist < threshold) && ~strcmp(name(1:5), matchName(1:5)))
            incorrectAcceptance = incorrectAcceptance + 1;            
        elseif ((dist > threshold) && strcmp(name(1:5), matchName(1:5)))
            %disp(['IR', num2str(dist)]);
            incorrectRejection = incorrectRejection + 1;
        end
    end
    
    % have tested every eye at this crop level. so, write an result, and
    % continue
    writeOutput(['Crop: ' , num2str(crop)]);
    writeOutput(['Correct Acceptances: ' num2str(correctAcceptance) '/' num2str(numberOfEntries)]);
    writeOutput(['Correct Rejections: ' num2str(correctRejection) '/' num2str(numberOfEntries)]);
    writeOutput(['Total Correct: ' num2str(correctAcceptance + correctRejection) '/' num2str(numberOfEntries)]);
    writeOutput(['Incorrect Acceptances: ' num2str(incorrectAcceptance) '/' num2str(numberOfEntries)]);
    writeOutput(['Incorrect Rejections: ' num2str(incorrectRejection) '/' num2str(numberOfEntries)]);
    writeOutput(['Total: ' num2str(correctAcceptance + correctRejection + ...
        incorrectAcceptance + incorrectRejection) '/' num2str(numberOfEntries)]);
    writeOutput(' ');
    
    allAcceptanceRate = [allAcceptanceRate, correctAcceptance];
    
end



end


% method to control whether to write to console or results CSV
function writeOutput(line)
disp(line);
fileWriter(line);
end

function fileWriter(line)
% open file for appending
dbFile = fopen('eyelidTestingv2.csv','a');
% add a newline char
line = ([line, '\n']);
% write
fprintf(dbFile, line);
% close file
fclose(dbFile);
end
