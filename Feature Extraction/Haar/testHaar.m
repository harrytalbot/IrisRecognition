% function to read in several
function [AList, IList, thresholdList] = testHaar(EYES, threshold, start, fin)

% start and end subject IDs, how many images per subject
[~, numberOfEntries] = size(EYES);

% for creating histograms
AList = [];
IList = [];

for thresholdIndex = 1:length(threshold)
    thresholdList(thresholdIndex).correct = 0;
    thresholdList(thresholdIndex).matchedCorrect = 0;
    thresholdList(thresholdIndex).incorrect = 0;
    thresholdList(thresholdIndex).FAR = 0;
    thresholdList(thresholdIndex).FRR = 0;
    thresholdList(thresholdIndex).impostersCompared = 0;
    thresholdList(thresholdIndex).authenticCompared = 0;
    
    %thresholdList(thresholdIndex).authenticList = [];
    %thresholdList(thresholdIndex).imposterList = [];
end

for subject = 1:numberOfEntries
    subjectName = EYES(subject).name;
    pupilRow = EYES(subject).pupilRow;
    pupilCol = EYES(subject).pupilCol;
    pupilRad = EYES(subject).pupilRad;
    irisRow = EYES(subject).irisRow;
    irisCol = EYES(subject).irisCol;
    irisRad = EYES(subject).irisRad;
    % normalise
    [normalisedIris, ~] = normalise(EYES(subject).original, pupilRow, pupilCol, ...
        pupilRad, irisRow, irisCol, irisRad, 60, 450, 0);
    % encode
    code = haarEncode(normalisedIris);
    % store in data
    data(subject).name = subjectName;
    data(subject).code = code;
end

% write back to workspace
assignin('base','haarData',data);

for subject = start:fin
    
    subjectName = data(subject).name;
    subjectCode = data(subject).code;
    
    matchName = [];
    dist = 10;
        
    for query = 1:numberOfEntries
        
        if (query == subject)
            continue;
        end
        
        queryName = data(query).name;
        queryCode = data(query).code;
        
        % ng et al hamming dist
        thisDist = getHammingDistHaar(subjectCode, queryCode);
        
        for thresholdIndex = 1:length(threshold)
            thisThreshold = threshold(thresholdIndex);
            if (strcmp(subjectName(1:6), queryName(1:6)) & thisDist < thisThreshold)
                %correct = correct + 1;
                %authenticCompared = authenticCompared + 1;
                %authenticList = [authenticList thisDist];
                
                thresholdList(thresholdIndex).correct = thresholdList(thresholdIndex).correct + 1;
                thresholdList(thresholdIndex).authenticCompared = thresholdList(thresholdIndex).authenticCompared + 1;
                
                %thresholdList(thresholdIndex).authenticList = [thresholdList(thresholdIndex).authenticList thisDist];

            elseif (~strcmp(subjectName(1:6), queryName(1:6)) & thisDist < thisThreshold)
                %FAR = FAR + 1;
                %impostersCompared = impostersCompared + 1;
                %imposterList = [imposterList thisDist];
                
                thresholdList(thresholdIndex).FAR = thresholdList(thresholdIndex).FAR + 1;
                thresholdList(thresholdIndex).impostersCompared = thresholdList(thresholdIndex).impostersCompared + 1;
                
                %thresholdList(thresholdIndex).imposterList = [thresholdList(thresholdIndex).imposterList thisDist];
                
            elseif (strcmp(subjectName(1:6), queryName(1:6)) & thisDist > thisThreshold)
                %FRR = FRR + 1;
                %authenticCompared = authenticCompared + 1;
                %authenticList = [authenticList thisDist];
                
                thresholdList(thresholdIndex).FRR = thresholdList(thresholdIndex).FRR + 1;
                thresholdList(thresholdIndex).authenticCompared = thresholdList(thresholdIndex).authenticCompared + 1;
                
                %thresholdList(thresholdIndex).authenticList = [thresholdList(thresholdIndex).authenticList thisDist];
                
            elseif (~strcmp(subjectName(1:6), queryName(1:6)) & thisDist > thisThreshold)
                %correct = correct + 1;
                %impostersCompared = impostersCompared + 1;
                %imposterList = [imposterList thisDist];
                
                thresholdList(thresholdIndex).correct = thresholdList(thresholdIndex).correct + 1;
                thresholdList(thresholdIndex).impostersCompared = thresholdList(thresholdIndex).impostersCompared + 1;
                
                %thresholdList(thresholdIndex).imposterList = [thresholdList(thresholdIndex).imposterList thisDist];             
            end  
        end
        
        if strcmp(subjectName(1:6), queryName(1:6))
            AList = [AList thisDist];
        else
            IList = [IList thisDist];
        end
        
        if (thisDist < dist)
            dist = thisDist;
            matchName = queryName;
        end
    end
    if strcmp(matchName(1:6), subjectName(1:6))
        thresholdList(thresholdIndex).matchedCorrect = thresholdList(thresholdIndex).matchedCorrect+1;
    end
end

% FAR = []; FRR = [];
% for i = 1:length(thresholdList)
%     FAR = [FAR thresholdList(i).FAR];
%     FRR = [FRR thresholdList(i).FRR];
% end

end

