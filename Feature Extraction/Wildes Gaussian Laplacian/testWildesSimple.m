function testWildesSimple(EYES)

% generate lap for every eye element
[~, numberOfEntries] = size(EYES);
tic;    
for i = 1:numberOfEntries
    % get the normalised image
    eye = alignIris(EYES(i).original, 200, EYES(i).irisRow, ...
        EYES(i).irisCol, EYES(i).irisRad);
    lap = gaussianLaplacian(eye);
    data(i).name = EYES(i).name;
    data(i).lap = lap;
end

correct = 0;
incorrect = 0;

for subject = 1:numberOfEntries
    
    subjectName = data(subject).name;
    subjectLap = data(subject).lap;
    matchName = [];
    dist = 1;
    
    for query = 1:numberOfEntries
        
        if (query == subject)
            continue;
        end
        
        queryName = data(query).name;
        queryLap = data(query).lap;
        
        matchVals = sum(normalisedCorrelation(subjectLap, queryLap));
 %       disp([queryName ' ' num2str(matchVals)]);
         if (matchVals > dist)
             dist = matchVals;
             matchName = queryName;
         end
    end
    
    disp([subjectName, ' matched with ' matchName, ', distance ' , num2str(dist)]);

    if strcmp(subjectName(1:5), matchName(1:5))
        correct = correct + 1;
    else
        incorrect = incorrect + 1;
    end
    
end
disp('');
disp(['Correct: ', num2str(correct)]);
disp(['Incorrect: ', num2str(incorrect)]);

disp([num2str((correct/numberOfEntries)*100), '%']);
toc;
end

