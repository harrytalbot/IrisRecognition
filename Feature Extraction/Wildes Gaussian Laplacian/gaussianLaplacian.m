function lap = gaussianLaplacian(image)

% http://www.cs.toronto.edu/~mangas/teaching/320/slides/CSC320L10.pdf
% w = [1/16, 4/16, 6/16, 4/16, 1/16];

W = [
    1/256, 4/256, 6/256, 4/256, 1/256;
    4/256, 16/256, 24/256, 16/256, 4/256;
    6/256, 24/256, 36/256, 24/256, 6/256;
    4/256, 16/256, 24/256, 16/256, 4/256;
    1/256, 4/256, 6/256, 4/256, 1/256;
    ];

kmax = 5;
filtered = cell(kmax);
lap = cell(kmax-1,1);

filtered{1} = image;
for k = 2:kmax
    image = imfilter(filtered{k-1}, W);
    filtered{k} = image;
end

% do resizing
filtered{2} = imresize(filtered{2}, 0.5);
filtered{3} = imresize(filtered{3}, 0.25);
filtered{4} = imresize(filtered{4}, 0.125);
filtered{5} = imresize(filtered{5}, 0.0625);

for k = 1:kmax-1
    bigImage = filtered{k};
    smallerImage = filtered{k+1};
    [height, width] = size(bigImage);
    
    upscaled = zeros(height, width);
    % rows anc cols of 0s
    upscaled(1:2:end,1:2:end) = smallerImage;
    times = 4;
    sub = imfilter(upscaled, times*W);
    lap{k} = bigImage - sub;
end

end