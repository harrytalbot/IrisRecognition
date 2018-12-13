% used to determine the best classifier. lapData must be in training
% format
function bestClassifiers = buildClassifiers(lapData, trainingPerEye, testingPerEye)
%function bestClassifiers = buildClassifiers(lapData, trainingPerEye, testingPerEye, trainingData, testingData)

trainingCounter = 0; testingCounter = 0;

% build the data
% for every subject
for i = 1:length(lapData)
    % for both sides
    for side = 1:2
        % check this training entry has something in side i.e != []
        if ~( structfun(@isempty, lapData(i)) )            
            % if side = 2, need to make sure that length is 2 as
            % well i.e. has a right eye, check not 1x1 as a left eye only
            % would be
            if ~(length(lapData(i).side) < side)
                % check there are enough eyes for this side
                if (length(lapData(i).side(side).eye) < trainingPerEye +  testingPerEye)
                    continue;
                end
                
                % get enough laplacians to use for training
                for t = 1:trainingPerEye
                    trainingCounter = trainingCounter+1;
                    eye = alignIris(lapData(i).side(side).eye(t).original, 200, lapData(i).side(side).eye(t).irisRow, ...
                        lapData(i).side(side).eye(t).irisCol, lapData(i).side(side).eye(t).irisRad);
                    lap = gaussianLaplacian(eye);
                    trainingData(trainingCounter).name = lapData(i).side(side).eye(t).name;
                    trainingData(trainingCounter).lap = lap;
                end
                
                for t = trainingPerEye+1:trainingPerEye + testingPerEye
                    testingCounter = testingCounter+1;
                    eye = alignIris(lapData(i).side(side).eye(t).original, 200, lapData(i).side(side).eye(t).irisRow, ...
                        lapData(i).side(side).eye(t).irisCol, lapData(i).side(side).eye(t).irisRad);
                    lap = gaussianLaplacian(eye);
                    testingData(testingCounter).name = lapData(i).side(side).eye(t).name;
                    testingData(testingCounter).lap = lap;
                end               
            end          
        end
    end
end

disp(['Testing size: ' num2str(testingCounter)]);
disp(['Training size: ' num2str(trainingCounter)]);

% write back to workspace
%assignin('base','lapTraining',trainingData);
%assignin('base','lapTesting',testingData);

% for every template build a classifier first (slow process)
for k = 1:length(trainingData)
    templateName = trainingData(k).name;    
    classifier = getClassifier(trainingData, templateName);   
    trainingData(k).classifier = classifier;
    clc;
    disp(['Testing size: ' num2str(testingCounter)]);
    disp(['Training size: ' num2str(trainingCounter)]);
    disp(['Classifiers built: ' num2str(k)]);
end

% write back to workspace
assignin('base','lapTraining',trainingData);

allCorrect = [];
allFAR = [];
allFRR = [];

previousTemplate = trainingData(1).name;
for k = 1:length(trainingData)
    templateName = trainingData(k).name;

    
    % check if we've just finished all templates for an eye
    if ~strcmp(previousTemplate(1:6), templateName(1:6))      
        best = 300;
        % if so, find which was best from minimised FAR FRR
        for check = k-testingPerEye:k-1
            if(trainingData(check).FARFRR < best)
                best = trainingData(check).FARFRR;
                n = check;
            end
        end       
        disp(['Best Classifier for ' templateName(3:5)  ': ' trainingData(n).name]); 
        disp(' ');
        bestClassifiers(str2num(templateName(3:5))) = {trainingData(n).classifier};
    end
    
    templateLap = trainingData(k).lap;
    compared = 0;
    correct = 0;
    falseAcceptances = 0;
    falseRejections = 0;
    classifier = trainingData(k).classifier;

    authenticsCompared = 0;
    impostersCompared = 0;
    % and test it with the testing data
    for j = 1:length(testingData)        
        subjectName = testingData(j).name;
        subjectLap = testingData(j).lap;
        % try match this person
        % get match values
        subjectVals = normalisedCorrelation(subjectLap, templateLap); 
        % predict
        pred = predict(classifier, subjectVals);
        % quantise result
        if strcmp(pred, 'Authentic')
            matched = 1;
        else
            matched = 0;
        end
        
        if (matched && strcmp(subjectName(1:6), templateName(1:6)))
            correct = correct + 1;
            authenticsCompared = authenticsCompared + 1;
        elseif(~matched && ~strcmp(subjectName(1:6), templateName(1:6)))
            correct = correct + 1;
            impostersCompared = impostersCompared + 1;
        elseif (matched && ~strcmp(subjectName(1:6), templateName(1:6)))
            falseAcceptances = falseAcceptances + 1;
            impostersCompared = impostersCompared + 1;
        elseif (~matched && strcmp(subjectName(1:6), templateName(1:6)))
            falseRejections = falseRejections + 1;
            authenticsCompared = authenticsCompared + 1;
        end
        compared = compared + 1;
    end    
    
    % results
    FAR = ((falseAcceptances/impostersCompared)*100);
    if isnan(FAR)
        FAR = 0;
    end
    FRR = ((falseRejections/authenticsCompared)*100);
    if isnan(FRR)
        FRR = 0;
    end
    
    acc = ((correct/compared)*100);
    disp([templateName ': ' num2str(acc) '%, FAR: ' num2str(FAR) ', FRR: ' ...
        num2str(FRR) ', FARFRR: ' num2str(FAR +FRR)]);
    allCorrect = [allCorrect acc];
    allFAR = [allFAR FAR];
    allFRR = [allFRR FRR]; 
    
    
    trainingData(k).acc = acc;
    trainingData(k).FAR = FAR;
    trainingData(k).FRR = FRR; 
    trainingData(k).FARFRR = FAR + FRR; 
    
    previousTemplate = templateName;
end

disp(' ');
disp(['Total: ' num2str(sum(allCorrect)/k) '%']);

end


function classifier = getClassifier(trainingData, templateName)

% find and remove the template data
ind = find(strcmp({trainingData.name}, templateName)==1);
templateLap = trainingData(ind).lap;
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

% build thing
classifier = fitcdiscr(vals, names, 'DiscrimType','quadratic');

end



