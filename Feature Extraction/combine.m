function thresholdList = combine(firstList, secondList, thirdList, fourthList, fifthList)

for thresholdIndex = 1:length(firstList)
thresholdList(thresholdIndex).correct = 0;
thresholdList(thresholdIndex).matchedCorrect = 0;
thresholdList(thresholdIndex).incorrect = 0;
thresholdList(thresholdIndex).FAR = 0;
thresholdList(thresholdIndex).FRR = 0;
thresholdList(thresholdIndex).impostersCompared = 0;
thresholdList(thresholdIndex).authenticCompared = 0;

end

for i = 1:length(firstList)
thresholdList(i).correct = thresholdList(i).correct + firstList(i).correct;
thresholdList(i).matchedCorrect = thresholdList(i).matchedCorrect + firstList(i).matchedCorrect;
thresholdList(i).FAR = thresholdList(i).FAR + firstList(i).FAR;
thresholdList(i).FRR = thresholdList(i).FRR + firstList(i).FRR;
thresholdList(i).impostersCompared = thresholdList(i).impostersCompared + firstList(i).impostersCompared;
thresholdList(i).authenticCompared = thresholdList(i).authenticCompared + firstList(i).authenticCompared;
end

for i = 1:length(secondList)
thresholdList(i).correct = thresholdList(i).correct + secondList(i).correct;
thresholdList(i).matchedCorrect = thresholdList(i).matchedCorrect + secondList(i).matchedCorrect;
thresholdList(i).FAR = thresholdList(i).FAR + secondList(i).FAR;
thresholdList(i).FRR = thresholdList(i).FRR + secondList(i).FRR;
thresholdList(i).impostersCompared = thresholdList(i).impostersCompared + secondList(i).impostersCompared;
thresholdList(i).authenticCompared = thresholdList(i).authenticCompared + secondList(i).authenticCompared;
end


for i = 1:length(thirdList)
thresholdList(i).correct = thresholdList(i).correct + thirdList(i).correct;
thresholdList(i).matchedCorrect = thresholdList(i).matchedCorrect + thirdList(i).matchedCorrect;
thresholdList(i).FAR = thresholdList(i).FAR + thirdList(i).FAR;
thresholdList(i).FRR = thresholdList(i).FRR + thirdList(i).FRR;
thresholdList(i).impostersCompared = thresholdList(i).impostersCompared + thirdList(i).impostersCompared;
thresholdList(i).authenticCompared = thresholdList(i).authenticCompared + thirdList(i).authenticCompared;
end


for i = 1:length(fourthList)
thresholdList(i).correct = thresholdList(i).correct + fourthList(i).correct;
thresholdList(i).matchedCorrect = thresholdList(i).matchedCorrect + fourthList(i).matchedCorrect;
thresholdList(i).FAR = thresholdList(i).FAR + fourthList(i).FAR;
thresholdList(i).FRR = thresholdList(i).FRR + fourthList(i).FRR;
thresholdList(i).impostersCompared = thresholdList(i).impostersCompared + fourthList(i).impostersCompared;
thresholdList(i).authenticCompared = thresholdList(i).authenticCompared + fourthList(i).authenticCompared;
end


for i = 1:length(fifthList)
thresholdList(i).correct = thresholdList(i).correct + fifthList(i).correct;
thresholdList(i).matchedCorrect = thresholdList(i).matchedCorrect + fifthList(i).matchedCorrect;
thresholdList(i).FAR = thresholdList(i).FAR + fifthList(i).FAR;
thresholdList(i).FRR = thresholdList(i).FRR + fifthList(i).FRR;
thresholdList(i).impostersCompared = thresholdList(i).impostersCompared + fifthList(i).impostersCompared;
thresholdList(i).authenticCompared = thresholdList(i).authenticCompared + fifthList(i).authenticCompared;

end


for thresholdIndex = 1:length(firstList)
    thresholdList(thresholdIndex).FAR = (( thresholdList(thresholdIndex).FAR/ thresholdList(thresholdIndex).impostersCompared)*100);   
    if isnan( thresholdList(thresholdIndex).FAR)
        thresholdList(thresholdIndex).FAR = 0;
    end
    
    thresholdList(thresholdIndex).FRR = (( thresholdList(thresholdIndex).FRR/ thresholdList(thresholdIndex).authenticCompared)*100);  
    if isnan( thresholdList(thresholdIndex).FRR)
        thresholdList(thresholdIndex).FRR = 0;
    end
    
end

FAR = []; FRR = [];
for i = 1:length(thresholdList)
    FAR = [FAR thresholdList(i).FAR];
    FRR = [FRR thresholdList(i).FRR];
end
