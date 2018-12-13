% segment and normalise two eyes, compare HD to threshold. 
% verbose - whether to write running info to console

function compareTwoEyes(eye1, eye2, localisationMethod, hammingThreshold, verbose)

% cells to hold the eye names
eyes = {eye1, eye2};
% where to look for the images
dataset = 'D:\Documents\IP\Datasets\Database';

% cells to hold the normalised iris images
eyeNormalised = cell(1,2);
% cells to hold the normalised iris noise
eyeNoise = cell(1,2);

% cells to hold the feature vector
eyeVector = cell(1,2);
% cells to hold the noise feature vector
noiseVector = cell(1,2);

% for each eye
for count = 1:2
    tic;
    % 3rd-5th char is the subject number
    ID = eyes{count}(3:5);
    % 6th char is L or R
    leftOrRight = eyes{count}(6);
    % Create an image filename for left eye
    nameWithExt = strcat(eyes{count},  '.jpg');
    fullName = fullfile(dataset, ID, leftOrRight, nameWithExt);
    % check if the eye exists (some eyes are missing images)
    if exist(fullName, 'file')
        if verbose
            disp(' '); disp([nameWithExt ' found.']);
        end
        % segment the eye
        [eyeNormalised{count}, eyeNoise{count}] = segment(fullName, localisationMethod, verbose);
        % create feature vector and noise vector
        [eyeVector{count}, noiseVector{count}] = wavelet2DExtract(eyeNormalised{count}, eyeNoise{count});
    else
        disp([eyes{count} ' does not exist.'])
        return;
    end
    toc;
end

% show the results
figure(1);
subplot(6,2,1), imshow(strcat(eyes{1}, '.jpg'));
subplot(6,2,2), imshow(strcat(eyes{2}, '.jpg'));
subplot(6,2,3),imshow(eyeNormalised{1});
subplot(6,2,4),imshow(eyeNormalised{2});
subplot(6,2,5),imshow(eyeNoise{1});
subplot(6,2,6),imshow(eyeNoise{2});
subplot(6,2,7),imshow(or(eyeNoise{1},eyeNoise{2}));
subplot(6,2,8),imshow(or(eyeNoise{1},eyeNoise{2}));
subplot(6,2,9),imshow(noiseVector{1});
subplot(6,2,10),imshow(noiseVector{2});
subplot(6,2,11),imshow(eyeVector{1});
subplot(6,2,12),imshow(eyeVector{2});

% find the similarity between the two iris' by comparing their feature
% vectors with the corresponding mask to exclude noise.
dist = getHammingDist(eyeVector{1}, noiseVector{1}, eyeVector{2}, noiseVector{2}, 2);

if (dist > hammingThreshold)
    disp(['Eyes are not a match. Distance ' num2str(dist) ' above threshold ' num2str(hammingThreshold)]);
else
    disp(['Eyes are a match! Distance ' num2str(dist) ' below threshold ' num2str(hammingThreshold)]);
end

end