function findBestParams(rootFolder)


directories = cell(5:1);
directories{1} = '\Sample_Set_16_128';%, fullfile(num2str(paddedID), LR));
directories{2} = '\Sample_Set_32_256';%, fullfile(num2str(paddedID), LR));
directories{3} = '\Sample_Set_64_512';%, fullfile(num2str(paddedID), LR));
directories{4} = '\Sample_Set_16_64';%, fullfile(num2str(paddedID), LR));
directories{5} = '\Sample_Set_32_32';%, fullfile(num2str(paddedID), LR));

for dir = 1:5
    for wavelength = 8
        for orientation = 0
            wando =['_' , num2str(wavelength), '_', num2str(orientation)];
            id = [directories{dir}(13:length(directories{dir})),' & ', num2str(wavelength),' & ', num2str(orientation)];
            disp(directories{dir});
            [EYES, counter] = loadDatabase(strcat(rootFolder, directories{dir}), wando);
            tic;
            testDatabase(EYES, 200, id);
            toc;
%             disp('');
        end
    end  
end
end