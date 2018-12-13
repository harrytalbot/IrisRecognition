function dist = getCumulativeHammingDist(subjectHorizontal, subjectVertical, subjectMask, ...
    queryHorizontal, queryVertical, queryMask)

[rows, cols] = size(subjectHorizontal);

% remove parts from mask
indicies = find(subjectMask == 1 & queryMask == 1);
subjectHorizontal(indicies) = []; queryHorizontal(indicies) = [];
subjectVertical(indicies) = []; queryVertical(indicies) = [];

% remove parts where both codes = 0;
indicies = find(subjectHorizontal == 0 & queryHorizontal == 0);
subjectHorizontal(indicies) = []; queryHorizontal(indicies) = [];
%subjectVertical(indicies) = []; queryVertical(indicies) = [];

indicies = find(subjectVertical == 0 & queryVertical == 0);
subjectVertical(indicies) = []; queryVertical(indicies) = [];
%subjectHorizontal(indicies) = []; queryHorizontal(indicies) = [];

% horizontal

horizontal = sum(xor(subjectHorizontal, queryHorizontal));

% vertical

vertical = sum(xor(subjectVertical, queryVertical));

% sum
vh = vertical + horizontal;
sh = length(subjectHorizontal);
sv = length(subjectVertical);
p = sh+sv;
nn = 2 * p;
dist = vh / (nn);

end