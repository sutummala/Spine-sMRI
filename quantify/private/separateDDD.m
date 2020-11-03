function AUC = separateDDD(g1, g2, tag1, tag2, tag3, visualize)

[X,Y,T,AUC, opt] = perfcurve([zeros(length(g1),1); ones(length(g2),1)], [g1'; g2'], 1, 'NBoot', 1000);
if sum(AUC(:)) < 1.5
    AUC = [1 1 1] - AUC;
    X = 1 - X; 
    Y = 1 - Y;
end

[h,p] = ttest2(g1, g2);

% Visualize the marker values w.r.t Grade
if visualize
%     bar(1:2, [mean(g1) mean(g2)], 'FaceColor',[0.5 0.5 0.5]);
%     hold on
%     errorbar(1:2, [mean(g1) mean(g2)], [std(g1) std(g2)], 'LineStyle','none','Color',[0 0 0]);
    figure
    plot(X(:,1), Y(:,1))
    xlabel('1-Specificity', 'FontSize', 16);
    ylabel('Sensitivity', 'FontSize', 16);
    title('ROC curve to separate D1D2 from D3D4D5', 'FontSize', 16);
end

fprintf('\np-value and AUC to separate %s with %s using %s is: %0.25f, %0.3f (%0.3f - %0.3f)\n', tag1, tag2, tag3, p, AUC(1), AUC(2), AUC(3));