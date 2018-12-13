function [allFAR, allFRR] = getCumulativeRates(EYES)

allFAR = [];
allFRR = [];
for threshold = 0:0.01:.3
    [FAR, FRR] = testCumulativeWithMask(EYES, threshold);
    disp(num2str([FAR, FRR]));
    allFAR = [allFAR FAR];
    allFRR = [allFRR FRR];
end

allFAR(end:end+30) = allFAR(end);
allFRR(end:end+30) = allFRR(end);

t = 0:0.01:.6;

plot(t, allFAR);
hold on;
plot(t, allFRR);
set(gcf, 'position', [400, 200, 500, 300]);
xlim([0 0.4]);
ylim([0 110]);
grid on;
ylabel('Probability (%)');
xlabel('Hamming Threshold');
legend('FAR', 'FRR');



end
