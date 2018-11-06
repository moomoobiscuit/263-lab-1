function obj = ObjFunction(X)
% This function returns the objective function
strike = X(1);
length = X(2);
dip = 68.287;
width = X(2);
slip = 1849.5;
open = 0.;
rake = 167.18;

% 239.81       68.287       14.413       1849.5            0       167.18

table = readtable('Grassmere2.csv','Delimiter',',','Format','%f%f%f%f%f%s');
LatEpic=-41.73; 
LonEpic=174.15; 
depth = 8;

obj = 0.;
for n = 1:size(table,1)
    N=(table.Latitude(n)-LatEpic)*pi*6400/180;
    E=(table.Longitude(n)-LonEpic)*pi*cos(LatEpic*pi/180)*6400/180; 
    [uE,uN,uZ] = okada85(E,N,depth,strike,dip,length,width,rake,slip,open);
    obj = obj + (uE-table.East(n))^2 + (uN-table.North(n))^2 + (uZ-table.Up(n))^2;
end
obj = log10(obj);