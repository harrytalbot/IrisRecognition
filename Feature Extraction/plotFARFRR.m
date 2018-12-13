function plotFARFRR(FAR, FRR, bins, EER)
plot(bins, FAR);
hold on;
plot(bins, FRR);
plot([EER EER], [0 100], 'Color', 'k');
text(EER-0.05,105,['t = ' num2str(EER)]);
set(gcf, 'position', [400 200 800 300]);
ylim([0 110]);
xlim([bins(1) bins(end)]);
grid on;
xlabel('Hamming Threshold');
ylabel('Probability (%)');