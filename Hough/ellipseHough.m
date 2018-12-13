function [centreY, centreX, a, b] = ellipseHough(processedEye, verbose)

[height, width] = size(processedEye);
processedEye = imgaussfilt(processedEye, 2);

processedEye = imresize(processedEye, [70, 80]);

aMin= 10; aMax = 35;
bMin = 10; bMax = 40;

if ~ismatrix(processedEye)
    % convert to grayscale if more than 2 dimensions (i.e. has channels)
    processedEye = rgb2gray(processedEye);
end

% find edges in image
edgeImage = edge(processedEye, 'Canny');
% get edges with find
imshow(edgeImage);
[edgesY, edgesX] = find(edgeImage == 1);

% create accumulator
Acc = zeros(height, width, aMax, bMax);

% loop every edgepoint
for n = 1:size(edgesY)
    % loop increasing radius
    %for r = rmin:rmax
    % radius in 10 degree steps
    for theta = 10:10:360
        for a = aMin:aMax
            for b = bMin:bMax
                
                x0 = ceil(edgesX(n) - (a * cosd(theta)));
                y0 = ceil(edgesY(n) - (b * sind(theta)));
                
                % check if point in boundries of image
                if ((x0 < width) && (x0 > 0) && (y0 < height) && (y0 > 0))
                    Acc(y0, x0, a, b) = Acc(y0, x0, a, b) + 1;
                end
            end
            %       end
            
        end
    end
end

% get max in accumilator
[M,I] = max(Acc(:));

if M > 0
    [centreX, centreY, a, b] = ind2sub(size(Acc),I);
    if verbose
        disp(['With ', num2str(Acc(centreX, centreY, a,b)) , ' votes: (' , ...
            num2str(centreY), ',',  num2str(centreX), '), a ', num2str(a), ', b ', num2str(b)]);
    end
end

end





