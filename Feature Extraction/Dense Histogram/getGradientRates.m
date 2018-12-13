function [allFAR, allFRR] = getGradientRates(EYES)

stepStart = 1500;
step = 50;
stepEnd = 5000;

allFAR = [];
allFRR = [];
disp('FAR FRR');
for threshold = stepStart:step:stepEnd
    [FAR, FRR] = testHistogram(EYES, threshold);
%    disp(num2str([FAR, FRR]));
    allFAR = [allFAR FAR];
    allFRR = [allFRR FRR];
end

allFAR(end:end) = allFAR(end);
allFRR(end:end) = allFRR(end);

t = stepStart:step:stepEnd;

plot(t, allFAR);
hold on;
plot(t, allFRR);
set(gcf, 'position', [400, 200, 800, 300]);
xlim([stepStart stepEnd]);
ylim([0 110]);
grid on;
ylabel('Probability (%)');
xlabel('Similarity Threshold');
legend('FAR', 'FRR');



end
