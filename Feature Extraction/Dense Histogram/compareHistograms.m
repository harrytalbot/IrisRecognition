% function to sum up the difference between two histograms

function matchLevel = compareHistograms(subjectHist, queryHist)

[rows, cols] = size(subjectHist);
matchLevel = 0;
blocksCompared = 0;

for rCounter = 1:rows
        for cCounter = 1:cols
            subjectBlock = subjectHist{rCounter, cCounter};
            queryBlock = queryHist{rCounter, cCounter};
            
            % if either of these are NaN they came from mask so skip
            if (isnan(subjectBlock) | isnan(queryBlock))
                continue;
            end
            
            % sum for this block
            blockSum = 0;
            % increment number of blocks normalised
            blocksCompared = blocksCompared+1;
            for i = 1:length(subjectBlock)
                % add on the difference
                blockSum = blockSum + abs(subjectBlock(i) - queryBlock(i));
            end
            
            matchLevel = matchLevel + blockSum;
            
        end
end
%disp(num2str(blocksCompared));
% normalise by dividing by number of blocks compared
%matchLevel = matchLevel / blocksCompared;

end
        