% function to get Hamming distance between two iris codes and their masks

function minDist = getHammingDistHaar(subjectCode, queryCode)

minDist = 1;
sCode = subjectCode;

[rows, cols] = size(subjectCode);

% will want to shift by 2 each time
for shifts = -1:1:1
%for shifts = 0

    subjectCode = shiftCode(sCode, shifts);
    
    % get the number of bits that will be compared for normalisation
    totalbits = (rows * cols);

    a = xor(subjectCode, queryCode);
    
    % count number of bits
    changed = sum(sum(a == 1));
    
    % normalise via comparing to the number in the codes being compared
    dist = changed/totalbits;
    
    if dist < minDist
        minDist = dist;
    end        
end

end


function shiftedCode = shiftCode(code, distance)

shiftedCode = zeros(size(code));
shiftedCode(:,:) = 0.2;

if (distance == 0)
    % no shift
    shiftedCode = code;
elseif (distance > 0 )
    % shift distance to the right
    % horizontal - 29 pixels wide at 1
    segmentStart = 1; segmentEnd = segmentStart + 29 - 1;
    shiftedCode(:,(segmentStart+distance:segmentEnd)) = code(:,(segmentStart:segmentEnd-distance));
    shiftedCode(:,(segmentStart:segmentStart+distance-1)) = code(:,(segmentEnd-distance+1:segmentEnd));
    % vertical - 28 pixels wide at 29
    segmentStart = segmentEnd + 1; segmentEnd = segmentStart + 28 - 1;
    shiftedCode(:,(segmentStart+distance:segmentEnd)) = code(:,(segmentStart:segmentEnd-distance));
    shiftedCode(:,(segmentStart:segmentStart+distance-1)) = code(:,(segmentEnd-distance+1:segmentEnd));
    % diagonal - 28 pixels wide
    segmentStart = segmentEnd + 1; segmentEnd = segmentStart + 28 - 1;
    shiftedCode(:,(segmentStart+distance:segmentEnd)) = code(:,(segmentStart:segmentEnd-distance));
    shiftedCode(:,(segmentStart:segmentStart+distance-1)) = code(:,(segmentEnd-distance+1:segmentEnd));
elseif (distance < 0)
    distance = abs(distance);
    % shift distance to the left
    % horizontal - 29 pixels wide at 1
    segmentStart = 1; segmentEnd = segmentStart + 29 - 1;
    shiftedCode(:,(segmentStart:segmentEnd-distance)) = code(:,(segmentStart+distance:segmentEnd));
    shiftedCode(:,(segmentEnd-distance+1:segmentEnd)) = code(:,(segmentStart:segmentStart+distance-1));
    % vertical - 28 pixels wide at 29
    segmentStart = segmentEnd + 1; segmentEnd = segmentStart + 28 - 1;
    shiftedCode(:,(segmentStart:segmentEnd-distance)) = code(:,(segmentStart+distance:segmentEnd));
    shiftedCode(:,(segmentEnd-distance+1:segmentEnd)) = code(:,(segmentStart:segmentStart+distance-1));
    % diagonal - 28 pixels wide
    segmentStart = segmentEnd + 1; segmentEnd = segmentStart + 28 - 1;
    shiftedCode(:,(segmentStart:segmentEnd-distance)) = code(:,(segmentStart+distance:segmentEnd));
    shiftedCode(:,(segmentEnd-distance+1:segmentEnd)) = code(:,(segmentStart:segmentStart+distance-1));

end

end
