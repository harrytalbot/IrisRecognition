% function to get Hamming distance between two iris codes and their masks

function minDist = getHammingDist(subjectCode, subjectMask, queryCode, queryMask)

minDist = 1;
sCode = subjectCode;
mCode = subjectMask;

[rows, cols] = size(subjectCode);

% will want to shift by 2 each time
for shifts = -16:2:16
%for shifts = 0

    subjectCode = shiftCode(sCode, shifts);
    subjectMask = shiftCode(mCode, shifts);
    
    % anywhere in mask that is a 1 should be ignored. so or the masks
    % together so that anywhere that is 1 in either is ignored
    maskBits = subjectMask | queryMask;
    % get the number of bits that will be compared for normalisation
    totalbits = (rows * cols) - sum(sum(maskBits == 1));
    
    % invert so that 1's indicate bits to keep
    maskBits = ~maskBits;
    
    a = xor(subjectCode, queryCode) & maskBits;
    
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

if (distance == 0)
    % no shift
    shiftedCode = code;
elseif (distance > 0 )
    % shift distance to the right
    shiftedCode(:,(distance+1:end)) = code(:,(1:end-distance));
    shiftedCode(:,(1:distance)) = code(:,(end-distance+1:end));
elseif (distance < 0)
    distance = abs(distance);
    % shift distance to the left
    shiftedCode(:,(1:end-distance)) = code(:,(distance+1:end));
    shiftedCode(:,(end-distance+1:end)) = code(:,(1:distance));
end

end
