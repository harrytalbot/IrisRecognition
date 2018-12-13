% IDO finds circle location with Daugman's Alg. called by localise
% centresCol, centresRow - Vectors where matching indexes give the column
%   and row position of a centrepoint.
% img - grayscale double image, gaussian blurred and imfilled
% rmin, rmax - radius bounds for circles
% displayFigures - flag on whether to produce graphs and bits
%
% returns centrepoints and radius of circles. Produces some figures.

function [centreCol, centreRow, circleRad] = IDOWithDisplay(centresCol, ...
    centresRow, img, rmin, rmax, verbose)

disp('Starting IDO Search.'); tic;
%centresCol = [164, 162, 160, 166, 168];
%centresRow = [156, 156, 156, 154, 158];
% hide warnings about peaks
warning('off','signal:findpeaks:largeMinPeakHeight');
[cols, rows] = size(img);
% for every identified possible centre
centreCount = length(centresRow);
% some more preallocation
IDOResults = cell(centreCount,3);
diffResults = cell(centreCount,6);
displayIDOResults = zeros(rmax, centreCount);
displayDiffResults = zeros(rmax-1, centreCount);

% map of peak to circle params
peaksMap = containers.Map('KeyType','double','ValueType','any');
% preallocatea
radvals = zeros(1,rmax);

% iterate every centre
for n = 1:centreCount
    % preallocate vector
    radvals(rmax) = 0;
    % iterate radius
    for radius = rmin:rmax
        %meshgrid of size r x c
        [rr, cc] = meshgrid(1:rows, 1:cols);
        % mask a circle with some leeway (given through variation in r^2
        mask = ((centresRow(n)-rr).^2 + (centresCol(n)-cc).^2 > (radius^2)-(0.5*radius)) & ...
            ((centresRow(n)-rr).^2 + (centresCol(n)-cc).^2 < (radius^2)+(0.5*radius));
        % DEBUG: imshow(mask) will show expanding circle as radius iterates
        % imshow(mask);
        % get number of 1 pixels by summing up values (0s or 1s)
        maskCoverage = sum(mask(:));
        % array multiplication and averaging
        maskedImage = img.*mask;
        value = sum(maskedImage(:)) / maskCoverage;
        % store normalised value at this radius
        radvals(radius)=value;
    end
    
    % for computational purposes put results in
    % cell array {x, y, [radvals]} for use
    IDOResults(n,1:3) = {centresRow(n), centresCol(n),radvals};
    % set threshold for drawing peaks
    peakThresh = 0.06;
    % get differential
    differences = diff(radvals);
    
    % for display purposes (vectors in columns)
    displayIDOResults(:,n) = radvals';
    displayDiffResults(:,n) = (diff(radvals))';
    
    [pks,locs] = findpeaks(differences, 'MinPeakHeight', peakThresh);
    % remove any locs lower than radius min i.e. the first tall spike that
    % is created from where we start searching
    index = find(locs <= rmin); locs(index) = []; pks(index) = [];
    
    % add to cell array of results
    diffResults(n,1:6) = {centresRow(n), centresCol(n), radvals, ...
        diff(radvals), pks, locs};
    % map all the good peaks for drawing, check there are peaks first
    if ~isempty(pks)
        for i = 1:length(pks)
            key = pks(i);
            val = sprintf('%d %d %f', [centresRow(n), centresCol(n), locs(i)]);
            peaksMap(key) = val;
        end
    end
end

disp('Search Finished'); toc;

% Display Figures
figure(2), subplot(1,2,1);%, title('Circumferential Values');
set(gcf, 'Position', [100, 100, 1000, 450])

hold on;
xlabel('Distance from Centre Point (Pixels)');
ylabel('Average Circumferential Pixel Value');
plot(displayIDOResults);
figure(2), subplot(1,2,2);%, title('CV Differential, and peaks');
hold on;
xlabel('Distance from Centre Point (Pixels)');
ylabel('Differential');
plot(displayDiffResults);
for j = 1:centreCount
    plot(diffResults{j,6}, diffResults{j,5}, 'r+', 'MarkerSize', 10);
end

figure(4);%, title('Potential Pupil Boundries');
imshow(img), hold on;
val = values(peaksMap);
for i = 1:3
    circleParams = strsplit(val{i});
    col = str2double(circleParams{1}); row = str2double(circleParams{2});
    rad = str2double(circleParams{3});
    %disp(int2str([col, row]));
    viscircles([col, row], rad, 'Color', 'b');
end


%get highest peak
key = keys(peaksMap); val = values(peaksMap);
[~, index] = max(cell2mat(key));
circleParams = strsplit(val{index});

centreCol = str2double(circleParams{1});
centreRow = str2double(circleParams{2});
circleRad = str2double(circleParams{3});

figure(5), title('Best Pupil Boundry from Highest Peak');
imshow(img), hold on;
viscircles([centreCol, centreRow], circleRad, 'Color', 'b');

disp(['Highest peak above ', num2str(peakThresh), ': (', num2str(centreCol), ...
    ',' , num2str(centreRow) , '), radius ' , num2str(circleRad)]);


end

