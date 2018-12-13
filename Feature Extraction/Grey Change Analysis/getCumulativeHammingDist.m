function dist = getCumulativeHammingDist(subjectHorizontal, subjectVertical, queryHorizontal, queryVertical)

[rows, cols] = size(subjectHorizontal);

% horizontal
% remove parts where both codes = 0;
indicies = find(subjectHorizontal == 0 & queryHorizontal == 0);
subjectHorizontal(indicies) = []; queryHorizontal(indicies) = [];
%subjectVertical(indicies) = []; queryVertical(indicies) = [];
    
indicies = find(subjectVertical == 0 & queryVertical == 0);
subjectVertical(indicies) = []; queryVertical(indicies) = [];
%subjectHorizontal(indicies) = []; queryHorizontal(indicies) = [];

horizontal = sum(xor(subjectHorizontal, queryHorizontal));

% vertical

vertical = sum(xor(subjectVertical, queryVertical));

% sum

%dist = 0.5 * length(horizontal) * (vertical + horizontal);
%dist = (1/(2 * (length(subjectHorizontal) + length(subjectVertical)))) * (vertical + horizontal);
vh = vertical + horizontal;
sh = length(subjectHorizontal);
sv = length(subjectVertical);
p = sh+sv;
nn = 2 * p;
dist = vh / (nn);end