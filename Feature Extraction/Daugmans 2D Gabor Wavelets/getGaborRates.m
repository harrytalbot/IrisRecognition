function [allFAR, allFRR] = getGaborRates(EYES)

allFAR = [];
allFRR = [];
threshold = 0:0.01:1;
[FAR, FRR, ~, ~, thresholdList] = testEncoding(EYES, threshold);    
    disp(num2str([FAR, FRR]));
    allFAR = [allFAR FAR];
    allFRR = [allFRR FRR];


t = 0:0.01:1;

allFAR(end:end+80) = allFAR(end);
allFRR(end:end+80) = allFRR(end);

plot(t, allFAR);
hold on;
plot(t, allFRR);
set(gcf, 'position', [400, 200, 800, 300]);
xlim([0 1]);
ylim([0 110]);
grid on;
ylabel('Probability (%)');
xlabel('Hamming Threshold');
legend('FAR', 'FRR');



end
