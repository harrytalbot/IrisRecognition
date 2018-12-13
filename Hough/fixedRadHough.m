function fixedRadHough(img)

eye = imread(img);

[rows, cols] = size(eye);

edgeImage = edge(eye, 'Canny');
[edgesCol, edgesRow] = find(edgeImage == 1);

rmin = 20; rmax = 100;

%create accumilator
maxA = 0; maxB = 0;
minA = 100000; minB = 10000000;
Acc = zeros(rows, cols);

%r=100;

for n = 1:size(edgesCol)
    %if edge less than threshold
    for r = rmin:rmax
        for theta = 5:5:360
            
            % matlab starting indexing from 1 is a pain so we will treat
            % index 1 as 0 and index 2 as 1 etc.
            t = theta * pi / 180;
            
            a = ceil(edgesRow(n) - (r * cos(t)));
            b = ceil(edgesCol(n) - (r * sin(t)));
            % disp([a b r]);
            %disp(num2str(Acc(a, b, r)));
            %disp([a+1, b+1, r]);
            
            if ((a < rows) && (a > 0) && (b < cols) && (b > 0))
                Acc(a, b) = Acc(a, b) + 1;
            end
            % disp(num2str(Acc(a, b, r)));
        end
    end
    
end
[M,I] = max(Acc(:));

[I_row, I_col] = ind2sub(size(Acc),I)
figure(1);
tt = surf(Acc);
set(tt,'LineStyle','none');

figure(3), imshow(eye), hold on;
viscircles([I_col, I_row], 110, 'Color', 'b');
plot(I_col, I_row, 'r+', 'MarkerSize', 10);



end





