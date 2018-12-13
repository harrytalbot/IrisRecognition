
% process all images in dataset using given method, and save resulting
% image to results folder. dataset must be in path, method must be 'hough'
% or 'ido'

function process(method)

resultsFolder = 'D:\Documents\IP\Results\Localisation Results';
dataset = 'D:\Documents\IP\Datasets\CASIA-Iris-Interval';


for identifer = 1:249 % there are max 249 subjects 
    for eye = 1:1 % there are max 11 images
        % pad with leading 0s if neccesary
        paddedID = sprintf('%03d',identifer);
        paddedEye = sprintf('%02d',eye);
        
        % Create an image filename for left eye
        name = strcat('S1', num2str(paddedID), 'L', num2str(paddedEye));
        nameWithExt = strcat(name,  '.jpg');
        fullName = fullfile(dataset, num2str(paddedID), 'L', nameWithExt);
        if exist(fullName, 'file')
            %don't need first few parameters
            [~, ~, ~, ~, ~, ~, locatedImg] = localise(imread(fullName), method, 1);
            saveas(locatedImg, ...
                fullfile(resultsFolder, strcat(name, '_', method)), 'jpeg');
        end
        
        % Create an image filename for right eye
        name = strcat('S1', num2str(paddedID), 'R', num2str(paddedEye));
        nameWithExt = strcat(name,  '.jpg');
        fullName = fullfile(dataset, num2str(paddedID), 'R', nameWithExt);
        if exist(fullName, 'file')
            %don't need first few parameters
            [~, ~, ~, ~, ~, ~, locatedImg] = localise(imread(fullName), method, 1);
            saveas(locatedImg, ...
                fullfile(resultsFolder, strcat(name, '_', method)), 'jpeg');
        end
        
    end
    
end


end
