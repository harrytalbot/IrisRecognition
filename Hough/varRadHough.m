function [centreRow, centreCol, circleRad] = varRadHough(processedEye, rMin, rMax, verbose)

[height, width] = size(processedEye);

if ~ismatrix(processedEye)
    % convert to grayscale if more than 2 dimensions (i.e. has channels)
    processedEye = rgb2gray(processedEye);
end

% find edges in image
edgeImage = edge(processedEye, 'Canny');
% get edges with find
[edgesY, edgesX] = find(edgeImage == 1);

% create accumulator
Acc = zeros(height, width, rMax);

% loop every edgepoint
for n = 1:size(edgesY)
    % loop increasing radius
    for r = rMin:rMax
        % radius in 10 degree steps
        for theta = 10:10:360
            
            x0 = ceil(edgesX(n) - (r * cosd(theta)));
            y0 = ceil(edgesY(n) - (r * sind(theta)));
            
            % check if point in boundries of image
            if ((x0 < width) && (x0 > 0) && (y0 < height) && (y0 > 0))
                Acc(y0, x0, r) = Acc(y0, x0, r) + 1;
            end
        end
    end
end

% get max in accumilator
[M,I] = max(Acc(:));

if M > 0
    [centreRow, centreCol, circleRad] = ind2sub(size(Acc),I);
    if verbose
        disp(['With ', num2str(Acc(centreCol, centreRow, circleRad)) , ' votes: (' , ...
            num2str(centreRow), ',',  num2str(centreCol), '), radius ', num2str(circleRad)]);
    end
end
end





