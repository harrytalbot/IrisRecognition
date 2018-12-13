function lineHough(img, irisX, radIris)

I  = imread(img);

I = imcomplement(imfill(imcomplement(I),'holes'));
I = imgaussfilt(I, 7);

BW =I;

BW = edge(I,'canny');
[rows, cols] = size(BW);
%BW(1:rows,1:irisX-radIris) = 0;
%BW(1:rows,irisX+radIris:cols) = 0;
imshow(BW);
[H,T,R] = hough(BW,'RhoResolution',10);

P  = houghpeaks(H,5,'threshold',ceil(0.4*max(H(:))));

lines = houghlines(BW,T,R,P,'FillGap',5,'MinLength',1);
figure, imshow(I), hold on

max_len = 0;

for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end

plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','cyan');


end