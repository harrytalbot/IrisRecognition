% function to match an eye

function [minDist, matchName] = match(EYES, name, subjectCode, subjectMask)

minDist = 1;

% loop through the cell array using the gethammingdist function
for counter = 1:size(EYES, 1)
    
    % if the row is blank, it is the end of the entries, and rest of array
    % is empty, so return
    
    if(isempty(EYES{counter, 1}))
        return;
    end
    
    % skip if we're matching the same eye image
    if (~strcmp(name, EYES(counter).name(1:5)))
        dist = getHammingDist(subjectCode, subjectMask, EYES(counter).code, EYES(counter).mask);
        if (dist < minDist)
            minDist = dist;
            matchName = EYES(counter).name;
        end
    end    
end

end