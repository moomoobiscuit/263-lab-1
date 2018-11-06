function MapCalibration(Path)

% Contour Plot
[x,y] = meshgrid(0.:1.:360.,0.:.2:20.);
Z = csvread([Path '\Contour.csv']);
hFig = figure(3);
clf(hFig);
v = 4.:.05:6.5;
[C,h] = contourf(x,y,Z,v); hold on;
set(h, 'linewidth', .01);
colormap(jet);
caxis([4., 6.5]);
colorbar

% Load calibration path
SaveFile = fopen([Path '\SaveFile.txt'],'r');
list_params = fscanf(SaveFile,'%f%f', [2 inf]);
fclose(SaveFile);
ListStrike = list_params(1,:);
ListLength = list_params(2,:);

% Plot calibration path
sz = 100;
pos = get(gca, 'Position');
for i=1:size(ListStrike,2)-1
    c = 'r';
    if i==size(ListStrike,2)-1
        c = 'g';
    end
    s=scatter(ListStrike(i+1),ListLength(i+1),sz,'k', 'marker', 'o', 'MarkerFaceColor', c);
end
for i=1:size(ListStrike,2)-1
    ls1 = ListStrike(i);
    ls2 = ListStrike(i+1);
    ll1 = ListLength(i);
    ll2 = ListLength(i+1);
    arrow('Start',[ls1 ll1],'Stop',[ls2 ll2],'Length',6);
end
scatter(ListStrike(1),ListLength(1),sz,'k', 'marker', 'o', 'MarkerFaceColor', 'b');
% p = plot(ListStrike, ListLength, 'k', 'linewidth', 1, 'marker', 'o', 'MarkerFaceColor', 'k');

% Plot settings
sb = scatter(-1,-1,sz,'k', 'marker', 'o', 'MarkerFaceColor', 'b');
sk = scatter(-1,-1,sz,'k', 'marker', 'o', 'MarkerFaceColor', 'r');
sg = scatter(-1,-1,sz,'k', 'marker', 'o', 'MarkerFaceColor', 'g');
legend([sb,sk,sg],'Initial guess','Intermediate guess','Final guess')
xlabel('Strike');
ylabel('Length');
axis([0. 360. 0. 20.]);
title('Objective function map');