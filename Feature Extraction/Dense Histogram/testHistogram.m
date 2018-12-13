function [AList, IList, thresholdList] = testHistogram(EYES, threshold, start, fin)

[~, numberOfEntries] = size(EYES);

% for creating histograms
AList = [];
IList = [];

matchedCorrect = 0;

for thresholdIndex = 1:length(threshold)
    thresholdList(thresholdIndex).correct = 0;
    thresholdList(thresholdIndex).matchedCorrect = 0;
    thresholdList(thresholdIndex).incorrect = 0;
    thresholdList(thresholdIndex).FAR = 0;
    thresholdList(thresholdIndex).FRR = 0;
    thresholdList(thresholdIndex).impostersCompared = 0;
    thresholdList(thresholdIndex).authenticCompared = 0;
    
    
%     thresholdList(thresholdIndex).authenticList = [];
%     thresholdList(thresholdIndex).imposterList = [];
end

% generate histogram for every eye element
for i = 1:numberOfEntries
    % get the normalised image
    norm = EYES(i).normalised;
    % get mask
    mask = EYES(i).mask;
    mask = imresize(mask,size(norm));
    
    % generate the histogram
    gradHist = gradientHistogram(norm);
    data(i).name = EYES(i).name;
    data(i).gradHist = gradHist;
end

for subject = start:fin
    
    subjectName = data(subject).name;
    subjectHist = data(subject).gradHist;
    matchName = [];
    dist = 1000000;
    
    for query = 1:numberOfEntries
        
        if (query == subject)
            continue;
        end
        
        queryName = data(query).name;
        queryHist = data(query).gradHist;
        
        thisDist = compareHistograms(subjectHist, queryHist);
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
                
                thresholdList(thresholdIndex).incorrect = thresholdList(thresholdIndex).incorrect + 1;
                thresholdList(thresholdIndex).FAR = thresholdList(thresholdIndex).FAR + 1;
                thresholdList(thresholdIndex).impostersCompared = thresholdList(thresholdIndex).impostersCompared + 1;
                
                %thresholdList(thresholdIndex).imposterList = [thresholdList(thresholdIndex).imposterList thisDist];
                
            elseif (strcmp(subjectName(1:6), queryName(1:6)) & thisDist > thisThreshold)
                %FRR = FRR + 1;
                %authenticCompared = authenticCompared + 1;
                %authenticList = [authenticList thisDist];
                
                thresholdList(thresholdIndex).incorrect = thresholdList(thresholdIndex).incorrect + 1;
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
