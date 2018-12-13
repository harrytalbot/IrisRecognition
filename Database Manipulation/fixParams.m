function fixParams(rootFolder)


% start and end subject IDs, how many images per subject
idStart = 1; idEnd = 249;

for identifier = idStart:idEnd % there are max 249 subjects
    for LR = ['L', 'R'] % two eyes
        % make a directory for this eye
        paddedID = sprintf('%03d',identifier);
        
        % if the dir doesn't exist in root, continue
        dir = fullfile(rootFolder, num2str(paddedID), LR);
        if ~(exist(dir, 'dir'))
            continue;
        end
        
        % read in params file
        allParams = csvread(fullfile(rootFolder, num2str(paddedID), LR, 'params.csv'));
        for i = 1:length(allParams);
            num = sprintf('%02d',allParams(i,1));
            name = strcat('S1', num2str(paddedI D), LR, num);
            pr = num2str(allParams(i,2));
            pc = num2str(allParams(i,3));
            pra = num2str(allParams(i,4));
            ir = num2str(allParams(i,5));
            ic = num2str(allParams(i,6));
            ira = num2str(allParams(i,7));
            line = [name ',' pr ',' pc ',' pra ',' ir ',' ic ',' ira];
            writeParams(line, rootFolder);
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