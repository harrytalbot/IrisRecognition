function [authenticList, imposterList] = testCumulative(EYES, threshold)
% generate histogram for every eye element
[~, numberOfEntries] = size(EYES);
tic;
for i = 1:numberOfEntries
    % get the normalised image
    norm = EYES(i).normalised;
    
    
    %[norm, ~] = normalise(EYES(i).original, EYES(i).pupilRow, EYES(i).pupilCol, ...
    %    EYES(i).pupilRad, EYES(i).irisRow, EYES(i).irisCol, EYES(i).irisRad, ...
    %    63, 600, 0);
    
    
    % generate the histogram
    [hori, vert] = getCumulativeCode(norm);
    data(i).name = EYES(i).name;
    data(i).hori = hori;
    data(i).vert = vert;
end
correct = 0;
incorrect = 0;
FAR = 0;
FRR = 0;
impostersCompared = 0;
authenticCompared = 0;

% for creating histograms
authenticList = [];
imposterList = [];

for subject = 1:numberOfEntries
    
    subjectName = data(subject).name;
    subjectHori = data(subject).hori;
    subjectVert = data(subject).vert;
    
    matchName = [];
    dist = 1;
    
    for query = 1:numberOfEntries
        
        if (query == subject)
            continue;
        end
        
        queryName = data(query).name;
        queryHori = data(query).hori; queryVert = data(query).vert;
        
        thisDist = getCumulativeHammingDist(subjectHori, subjectVert, queryHori, queryVert);
        
        if (strcmp(subjectName(1:6), queryName(1:6)) & thisDist < threshold)
            correct = correct + 1;
            authenticCompared = authenticCompared + 1;
            authenticList = [authenticList thisDist];
        elseif (~strcmp(subjectName(1:6), queryName(1:6)) & thisDist < threshold)
            FAR = FAR + 1;
            impostersCompared = impostersCompared + 1;
            imposterList = [imposterList thisDist];    
        elseif (strcmp(subjectName(1:6), queryName(1:6)) & thisDist > threshold)
            FRR = FRR + 1;
            authenticCompared = authenticCompared + 1;
            authenticList = [authenticList thisDist];
        elseif (~strcmp(subjectName(1:6), queryName(1:6)) & thisDist > threshold)
            correct = correct + 1;
            impostersCompared = impostersCompared + 1;
            imposterList = [imposterList thisDist];
        end
    end
    
    
    %disp([subjectName, ' matched with ' matchName, ', distance ' , num2str(dist)]);
    
end

disp('');
disp(['Correct: ', num2str(correct)]);
FAR = ((FAR/impostersCompared)*100);
if isnan(FAR)
    FAR = 0;
end
FRR = ((FRR/authenticCompared)*100);
if isnan(FRR)
    FRR = 0;
end
disp(['FAR: ', num2str(FAR)]);
disp(['FRR: ', num2str(FRR)]);

disp([num2str((correct/numberOfEntries)*100), '%']);
toc;
end


