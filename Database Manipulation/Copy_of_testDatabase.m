function [problemMatch, problemSubject] = testDatabase(EYESOLD, numberOfEntries)

threshold = .32;
correctAcceptance = 0; correctRejection = 0;
incorrectAcceptance = 0; incorrectRejection = 0;

problemMatch = zeros(numberOfEntries, 1);
problemSubject = zeros(numberOfEntries, 1);
location = 'console';
figure;
for crop = 32:-1:16
    correctAcceptance = 0; correctRejection = 0;
    incorrectAcceptance = 0; incorrectRejection = 0;
    
    for i = 1:numberOfEntries
             
        % crop
        normalised = EYESOLD{i, 2};
        mask = EYESOLD{i, 3};
        normalised = normalised((1:crop),:);
        mask = mask((1:crop),:);

        % encode
        [featureVector, noiseVector] = wavelet2DExtract(normalised, mask, 6, 0);
        EYES{i,1} = EYESOLD{i, 1}; 
        EYES{i,2} = featureVector;
        EYES{i,3} = noiseVector;
        
    end
    imshow(normalised);   
    
    for i = 1:numberOfEntries
        % last few bits of the array are empty. if so we've reached the end so
        % break
        if (isempty(EYES{i, 1}))
            break;
        end
        
        identifier = EYES{i, 1};
        feature = EYES{i, 2};
        mask = EYES {i, 3};

        dist = 1;
        
        numberOfMatches=0;
        
        for j = 1:numberOfEntries
            % if the id matches the hammming dist will be 0 (same image) so
            % continue
            if (j == i)
                continue;
            end
            % last few bits of the array are empty. if so we've reached the end so
            % break
            if (isempty( EYES{j, 1}))
                break;
            end
            
            featureQuery = EYES{j, 2};
            maskQuery = EYES{j, 3};
            
            thisDist = getHammingDist(feature, mask, featureQuery, maskQuery);
            if (thisDist < dist)
                numberOfMatches = numberOfMatches + 1;
                dist = thisDist;
                matchIdentifer = EYES{j, 1};
                line = [matchIdentifer(1:5), '-', num2str(dist)];
                matches{numberOfMatches} = line;
            end
        end
        
        line = [identifier, ' - ', matchIdentifer, ' - ', num2str(dist)];
        
        
        % check if correct
        if ((dist < threshold) && strcmp(identifier(1:5), matchIdentifer(1:5)))
            correctAcceptance = correctAcceptance + 1;
            %writeOutput([line ', CORRECT ACCEPTANCE'], location);
        elseif ((dist > threshold) && ~strcmp(identifier(1:5), matchIdentifer(1:5)))
            correctRejection = correctRejection + 1;
            % writeOutput([line ', CORRECT REJECTION']);
        elseif ((dist < threshold) && ~strcmp(identifier(1:5), matchIdentifer(1:5)))
            incorrectAcceptance = incorrectAcceptance + 1;
            % writeOutput([line ', INCORRECT ACCEPTANCE']);
            
            %problemMatch(str2num(matchIdentifer(3:5))) = problemMatch(str2num(matchIdentifer(3:5)))+1;
            %problemSubject(str2num(identifier(3:5))) = problemSubject(str2num(identifier(3:5)))+1;
            % for k = 1:numberOfMatches
            %   writeOutput(matches{k}, location);
            %end
            
        elseif ((dist > threshold) && strcmp(identifier(1:5), matchIdentifer(1:5)))
            incorrectRejection = incorrectRejection + 1;
            % writeOutput([line ', INCORRECT REJECTION']);
        end
        
        
    end
    
    %record = [id, ' & ', num2str(correctAcceptance), ' & ' ...
    %    num2str(correctRejection),' & ' ...
    %    num2str(incorrectAcceptance),' & ' ...
    %    num2str(incorrectRejection), ' \\'];
    
    writeOutput(['Crop: ' , num2str(crop)]);
    
    writeOutput(['Correct Acceptances: ' num2str(correctAcceptance) '/' num2str(numberOfEntries)]);
    writeOutput(['Correct Rejections: ' num2str(correctRejection) '/' num2str(numberOfEntries)]);
    writeOutput(['Total Correct: ' num2str(correctAcceptance + correctRejection) '/' num2str(numberOfEntries)]);
    writeOutput(['Incorrect Acceptances: ' num2str(incorrectAcceptance) '/' num2str(numberOfEntries)]);
    writeOutput(['Incorrect Rejections: ' num2str(incorrectRejection) '/' num2str(numberOfEntries)]);
    writeOutput(['Total: ' num2str(correctAcceptance + correctRejection + ...
        incorrectAcceptance + incorrectRejection) '/' num2str(numberOfEntries)]);
    writeOutput(' ');
end
end


% method to control whether to write to console or results CSV
function writeOutput(line)
disp(line);
fileWriter(line);
end

% DO NOT CALL THIS METHOD
% ACCESS VIA writeOutput
function fileWriter(line)
% open file for appending
dbFile = fopen('eyelidTesting.csv','a');
% add a newline char
line = ([line, '\n']);
% write
fprintf(dbFile, line);
% close file
fclose(dbFile);
end
