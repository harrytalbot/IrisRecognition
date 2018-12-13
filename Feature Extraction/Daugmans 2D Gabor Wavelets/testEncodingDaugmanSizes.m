% function to read in several
function results = testEncoding(EYES, threshold)


% start and end subject IDs, how many images per subject
[~, numberOfEntries] = size(EYES);

counter = 0;

for wavelength = [2 10]
    disp(['Doing ' num2str(wavelength)]);
    for orientation = [135]
        counter = counter + 1;
        

        
        %generate all the codes
        for subject = 1:numberOfEntries
            subjectName = EYES(subject).name;
            pupilRow = EYES(subject).pupilRow;
            pupilCol = EYES(subject).pupilCol;
            pupilRad = EYES(subject).pupilRad;
            irisRow = EYES(subject).irisRow;
            irisCol = EYES(subject).irisCol;
            irisRad = EYES(subject).irisRad;
            % normalise
            [normalisedIris, occludedNoise] = normalise(EYES(subject).original, pupilRow, pupilCol, ...
                pupilRad, irisRow, irisCol, irisRad, 16, 64, 0);
            % encode
            [code, mask] = wavelet2DExtract(normalisedIris, occludedNoise, wavelength, orientation);
            % store in data
            data(subject).name = subjectName;
            data(subject).code = code;
            data(subject).mask = mask;
        end
        
        correct = 0;
        compared = 0;
        FAR = 0;
        FRR = 0;
        impostersCompared = 0;
        authenticCompared = 0;
        
        % for creating histograms
        authenticList = [];
        imposterList = [];
        
        % loop the data
        for subject = 1:numberOfEntries
            
            subjectCode = data(subject).code;
            subjectMask = data(subject).mask;
            
            matchName = [];
            dist = 1;
            
            %save every 10
            if ~(mod(subject-1, 10))
                upto = num2str(subject-1);
                name = ['G:\IP\Matlab Projects\aList,iList,FAR,FRR\0upto' upto '.mat'];
                % save(name, 'thresholdList');
            end

            
            for query = 1:numberOfEntries
                
                if (query == subject)
                    continue;
                end
                
                queryName = data(query).name;
                queryCode = data(query).code;
                queryMask = data(query).mask;
                
                % get the distance
                thisDist = getHammingDist(subjectCode, subjectMask, queryCode, queryMask);
                
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
                
                compared = compared + 1;
            end
        end
        
        
        
        FAR = (FAR/ impostersCompared)*100;
        if isnan(FAR)
            FAR = 0;
        end
        
        FRR = (FRR/ authenticCompared)*100;
        if isnan( FRR)
            FRR = 0;
        end
        
        
        % results
        results(counter).orientation = orientation;
        results(counter).wavelength = wavelength;
        results(counter).FAR = FAR;
        results(counter).FRR = FRR;
        results(counter).accuracy = ((correct/compared)*100);
    end
end


end

