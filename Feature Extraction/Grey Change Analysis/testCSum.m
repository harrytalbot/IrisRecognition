function [AList, IList, thresholdList] = testCSum(EYES, threshold, start, fin)

% generate histogram for every eye element
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

for i = 1:numberOfEntries
    % get the normalised image
    norm = EYES(i).normalised;
    
    % generate the histogram
    [hori, vert] = getCumulativeCode(norm);
    data(i).name = EYES(i).name;
    data(i).hori = hori;
    data(i).vert = vert;
end

for subject = start:fin
    
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
