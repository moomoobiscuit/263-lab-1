function PlotH0(strike, length, Path)

% Contour vectors
Xlim = [173.1 175.2];
Ylim = [-42.2 -41.];
[x,y] = meshgrid(Xlim(1):.025:Xlim(2),Ylim(1):.01:Ylim(2));

% EQ data
LatEpic=-41.73; 
LonEpic=174.15; 
scaling = .002;
table = readtable('Grassmere2.csv','Delimiter',',','Format','%f%f%f%f%f%s');
table(1:10,{'Name'});
N_color = 10;
FaultWidth = 1.5;

% Save values in history file
SaveFile = fopen([Path '\SaveFile.txt'],'w');
fprintf(SaveFile, '%f %f \n', [strike length]);
fclose(SaveFile);

% Open figure
hFig = figure(1);
clf(hFig);
set(hFig, 'name', 'Displacement plot','numbertitle','off');
set(hFig, 'Position', [0 200 1850 650]);

% Calculate overall displacement
[uE, uN, uZ] = okada5(x, y, strike, length);
u = sqrt(uE.^2+uN.^2+uZ.^2);
N_max = 300.;
N_contour = int8(N_color*max(max(u))/N_max);

% Calculate displacement at stations
[uE_st, uN_st, uZ_st] = okada5(table.Longitude, table.Latitude, strike, length);

% PLOT DIRECTION
% Open subplot
subplot(1,2,1)

% Plot contour
[C,h] = contourf(x,y,u, N_contour); hold on;
set(h, 'lineColor', 'none');
polarmap(jet);
caxis([-N_max, N_max]);

% Plot calculated displacement direction
[x2,y2] = meshgrid(Xlim(1):.25:Xlim(2),Ylim(1):.1:Ylim(2));
[uE2, uN2, uZ2] = okada5(x2, y2, strike, length);
size_arrow = .1;
uE_scaled = size_arrow*uE2.*1./sqrt(uE2.^2+uN2.^2);
uN_scaled = size_arrow*uN2.*1./sqrt(uE2.^2+uN2.^2);
qC = quiver(x2, y2, uE_scaled, uN_scaled, 0, 'color', 'k'); hold on;

% Plot the original displacement direction
uE2_scaled = size_arrow*table.East.*1./sqrt(table.East.^2+table.North.^2);
uN2_scaled = size_arrow*table.North.*1./sqrt(table.East.^2+table.North.^2);
qD = quiver(table.Longitude, table.Latitude, uE2_scaled, uN2_scaled, 0, 'color', 'r'); hold on;

% Plot stations
scatter(table.Longitude, table.Latitude, 'k', 'filled'); hold on;

% Plot Coast line
for Island = {'South_Island.csv' 'North_Island.csv' 'Kapiti.csv'}
    SI = readtable(Island{:},'Delimiter',',','Format','%f%f');
    plot(SI.Longitude+0.05, SI.Latitude, 'color', [0 0 0]); hold on;
    f = fill(SI.Longitude+0.05, SI.Latitude, [0 .255 .127]); hold on;
    set(f, 'facealpha',.2);
end

% Plot fault
X_event = .5*length*sin(strike*pi/180)/(pi*cos(LatEpic*pi/180)*6400/180);
Y_event = .5*length*cos(strike*pi/180)/(pi*6400/180);
fault = plot([LonEpic+X_event LonEpic-X_event],[LatEpic+Y_event LatEpic-Y_event], 'color', 'b'); hold on;
fault.LineWidth = FaultWidth;
Ngap = int8(length/2);
gap = .005;
gap_x = gap*cos(strike*pi/180.)/cos(LatEpic*pi/180);
gap_y = -gap*sin(strike*pi/180.);
list_gap_x = linspace(LonEpic+X_event+gap_x,LonEpic-X_event+gap_x,Ngap);
list_gap_y = linspace(LatEpic+Y_event+gap_y,LatEpic-Y_event+gap_y,Ngap);
scatter(list_gap_x,list_gap_y,10.,'b','filled','marker','o'); hold on;

% % Plot 20 km ax
% Scale = 20.;
% plot([LonEpic-1 LonEpic-1+Scale*180/(pi*6400*cos(LatEpic*pi/180))],[LatEpic LatEpic], 'color', 'k'); hold on;
% plot([LonEpic-1 LonEpic-1],[LatEpic LatEpic+Scale*180/(pi*6400)], 'color', 'k'); hold on;

% Plot angle
plot([LonEpic LonEpic],[LatEpic LatEpic+.08], 'color', 'k'); hold on;
a = .05;
b = .04;
list_theta = [0.:.1:strike*pi/180];
x_segment = a*sin(list_theta)+LonEpic;
y_segment = b*cos(list_theta)+LatEpic;
plot(x_segment,y_segment, 'color', 'k'); hold on;

% plot settings
axis([Xlim Ylim]);
legend([fault, qC, qD],'Fault','Calculated','Data','Location','southeast')
xlabel('Longitude');
ylabel('Latitude');
title('Direction of horizontal displacement');
grid

% PLOT INTENSITY
% Open second subplot
subplot(1,2,2)

% Plot contour
[C,h] = contourf(x,y,u, N_contour); hold on;
set(h, 'lineColor', 'none');
polarmap(parula);
caxis([-N_max, N_max]);

% Plot calculated displacement at the stations
qC = quiver(table.Longitude, table.Latitude, uE_st*scaling, uN_st*scaling, 0, 'color', 'k'); hold on;

% Plot the original displacement
qD = quiver(table.Longitude, table.Latitude, table.East*scaling, table.North*scaling, 0, 'color', 'r'); hold on;

% Plot stations
scatter(table.Longitude, table.Latitude, 'k', 'filled'); hold on;

% Plot Coast line
for Island = {'South_Island.csv' 'North_Island.csv' 'Kapiti.csv'}
    SI = readtable(Island{:},'Delimiter',',','Format','%f%f');
    plot(SI.Longitude+0.05, SI.Latitude, 'color', [0 0 0]); hold on;
    f = fill(SI.Longitude+0.05, SI.Latitude, [0 .255 .127]); hold on;
    set(f, 'facealpha',.2);
end   

% Plot fault
fault = plot([LonEpic+X_event LonEpic-X_event],[LatEpic+Y_event LatEpic-Y_event], 'color', 'b'); hold on;
fault.LineWidth = FaultWidth;
scatter(list_gap_x,list_gap_y,10.,'b','filled','marker','o'); hold on;

% Plot settings
axis([Xlim Ylim]);
legend([fault, qC, qD],'Fault','Calculated','Data','Location','southeast')
xlabel('Longitude');
ylabel('Latitude');
title('Intensity of horizontal displacement');
grid;

% Annotations
obj = ObjFunction([strike length]);
Xmin = [0. 0.01];
Xmax = [360. 30.];
J = Jacobian4([strike, length], Xmin, Xmax);
s = ['Strike: ' num2str(strike) '°, Length: ' num2str(length) 'km, Objective function: ' num2str(obj)];
s = [s char(10) 'Gradient strike: ' num2str(J(1)) ', Gradient length: ' num2str(J(2))];
t = annotation('textbox',[.15 0. .3 .2],'String',s,'FitBoxToText','on','BackgroundColor','w');
t = annotation('textbox',[.6 0. .3 .2],'String',s,'FitBoxToText','on','BackgroundColor','w');