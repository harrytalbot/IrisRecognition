function training = getTrainingFormat(EYES)

for i = 1:length(EYES)
    name = EYES(i).name;
    
    id = str2num(name(3:5));
    if strcmp(name(6), 'L')
        side = 1;
    else
        side = 2;
    end
   
    eye =  str2num(name(7:8));   
    %bunch them together
    %eye = length(training(id).side(side).eye) + 1;
        
    training(id).side(side).eye(eye).name = EYES(i).name;
    training(id).side(side).eye(eye).original = EYES(i).original;
    training(id).side(side).eye(eye).normalised = EYES(i).normalised;
    training(id).side(side).eye(eye).code = EYES(i).code;
    training(id).side(side).eye(eye).mask = EYES(i).mask;
    training(id).side(side).eye(eye).pupilRow = EYES(i).pupilRow;
    training(id).side(side).eye(eye).pupilCol = EYES(i).pupilCol;
    training(id).side(side).eye(eye).pupilRad = EYES(i).pupilRad;
    training(id).side(side).eye(eye).irisRow = EYES(i).irisRow;
    training(id).side(side).eye(eye).irisCol = EYES(i).irisCol;
    training(id).side(side).eye(eye).irisRad = EYES(i).irisRad;
end

