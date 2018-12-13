function encoding = haarEncode(img)

[rows, cols] = size(img);

% takes 4th level
[~,h,v,d] = haart2(img,4); 
% combine the detail
combined = [h{4} v{4} d{4}];
% generate a ones array of the same size
encoding = ones(size(combined));
% set any less than 0 in combined to 0, leave others as 0 (positive)
negativeInd =  find(combined < 0);
encoding(negativeInd) = 0;

end

