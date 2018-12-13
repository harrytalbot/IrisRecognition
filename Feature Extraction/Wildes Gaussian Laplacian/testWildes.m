function [allFAR, allFRR] = testWildes(EYES)

% build the data
for i = 1:length(EYES)
    % get the normalised image
    eye = alignIris(EYES(i).original, 200, EYES(i).irisRow, ...
        EYES(i).irisCol, EYES(i).irisRad);
    lap = gaussianLaplacian(eye);
    trainingData(i).name = EYES(i).name;
    trainingData(i).lap = lap;    
end

allCorrect = [];
allFAR = [];
allFRR = [];

% for every template
for k = 1:length(EYES)
    templateName = EYES(k).name;
    compared = 0;
    correct = 0;
    FAR = 0;
    FRR = 0;
    
    authenticsCompared = 0;
    impostersCompared = 0;
    % for every subject to identify  
    for j = 1:length(EYES)
        % subject will be removed from the training data, the rest of
        % the data then used with template to build lda
        subjectName = EYES(j).name;
        % if the person matches template skip
        if strcmp(templateName,subjectName)
            continue;
        end
        % try match this person
        [matched, ~] = twildes(trainingData, templateName, subjectName);
        
        if (matched && strcmp(subjectName(1:6), templateName(1:6)))
            correct = correct + 1;
            authenticsCompared = authenticsCompared + 1;
        elseif(~matched && ~strcmp(subjectName(1:6), templateName(1:6)))
            correct = correct + 1;
            impostersCompared = impostersCompared + 1;
        elseif (matched && ~strcmp(subjectName(1:6), templateName(1:6)))
            FAR = FAR + 1;
            impostersCompared = impostersCompared + 1;
        elseif (~matched && strcmp(subjectName(1:6), templateName(1:6)))
             FRR = FRR + 1;
            authenticsCompared = authenticsCompared + 1;
        end
        compared = compared + 1;
    end
    
    
    FAR = ((FAR/impostersCompared)*100);
    if isnan(FAR)
        FAR = 0;
    end
    FRR = ((FRR/authenticsCompared)*100);
    if isnan(FRR)
        FRR = 0;
    end
    
    acc = ((correct/compared)*100);
    disp([templateName ': ' num2str(acc) '%, FAR: ' num2str(FAR) ', FRR: ' num2str(FRR)]);
    allCorrect = [allCorrect acc];
    allFAR = [allFAR FAR];
    allFRR = [allFRR FRR];
    
    results(k).lda = 
    
end
disp(' ');
disp(['Total: ' num2str(sum(allCorrect)/k) '%']);

end

function [prediction, classifier] = twildes(trainingData, templateName, subjectName)

% find and remove the subject and template data
ind = find(strcmp({trainingData.name}, templateName)==1);
templateLap = trainingData(ind).lap;
trainingData(ind) = [];

ind = find(strcmp({trainingData.name}, subjectName)==1);
subjectLap = trainingData(ind).lap;
trainingData(ind) = [];

% get match values
for training = 1:length(trainingData)
    trainingName = trainingData(training).name;
    trainingLap = trainingData(training).lap;
    
    matchVals = normalisedCorrelation(templateLap, trainingLap);
    vals(training,1:4) = matchVals;
    
    if strcmp(trainingName(1:6), templateName(1:6))
        names{training,1} = 'Authentic';
    else
        names{training,1} = 'Imposter';
    end
end

% and for subject
subjectVals = normalisedCorrelation(templateLap, subjectLap);

% build thing
classifier = fitcdiscr(vals, names);

% predict
pred = predict(classifier, subjectVals);

if strcmp(pred, 'Authentic')
    prediction = 1;
else
    prediction = 0;
end

end



