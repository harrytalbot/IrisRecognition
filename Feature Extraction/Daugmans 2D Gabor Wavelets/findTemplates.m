% function to read in several
function findTemplates(EYES)

% where to write output
location = 'console';
% start and end subject IDs, how many images per subject
[~, numberOfEntries] = size(EYES);

correctAcceptance = 0;
incorrectAcceptance = 0;

correctRejection = 0;
incorrectRejection = 0;



for subject = 7:numberOfEntries
    for LR = ['R','R']
        paddedSubject = sprintf('%03d',subject);
        line = ['S1' num2str(paddedSubject) LR '[0123456789]+'];
        ind = find(regexp([EYES.name], line));
        distances = nan(length(ind));
        
        for inClass = 1:length(ind)
            
            subjectName = EYES(inClass).name;
            subjectCode = EYES(inClass).code;
            subjectMask = EYES(inClass).mask;
            
            for remainingInClass = inClass:length(ind)
                queryName = EYES(remainingInClass).name;
                queryCode = EYES(remainingInClass).code;
                queryMask = EYES(remainingInClass).mask;
                if (remainingInClass == inClass)
                    continue;
                end
                thisDist = getHammingDist(subjectCode, subjectMask, queryCode, queryMask);
                distances(inClass, remainingInClass) = thisDist;              
                distances(remainingInClass,inClass) = thisDist;
            end
            
        end
        for dists = 1:length(ind)
            disp(num2str(distances(dists,:)));
        end
        
        1;
    end
end

disp(['Correct Acceptances: ' num2str(correctAcceptance) '/' num2str(numberOfEntries)]);
disp(['Correct Rejections: ' num2str(correctRejection) '/' num2str(numberOfEntries)]);
disp(['Total Correct: ' num2str(correctAcceptance + correctRejection) '/' num2str(numberOfEntries)]);
disp(['Incorrect Acceptances: ' num2str(incorrectAcceptance) '/' num2str(numberOfEntries)]);
disp(['Incorrect Rejections: ' num2str(incorrectRejection) '/' num2str(numberOfEntries)]);
disp(['Total: ' num2str(correctAcceptance + correctRejection + ...
    incorrectAcceptance + incorrectRejection) '/' num2str(numberOfEntries)]);

end

% method to control whether to write to console or results CSV
function writeOutput(line, location)
if (location == 'console')
    disp(line);
elseif (location == 'results')
    fileWriter(line);
end
end

% DO NOT CALL THIS METHOD
% ACCESS VIA writeOutput
function fileWriter(line)
% open file for appending
resultsFile = fopen('results.csv','a');
% add a newline char
line = ([line, '\n']);
% write
fprintf(resultsFile, line);
% close file
fclose(resultsFile);
end
