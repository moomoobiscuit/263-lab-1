function [uE,uN,uZ] = okada5(x, y, strike, length)
% This function takes the only two calibration parameters, only for
% Grassmere
dip = 68.287;
width = length;   %km
slip = 1849.5;  %mm
open = 0.;  %mm
rake = 167.18;

table = readtable('Grassmere2.csv','Delimiter',',','Format','%f%f%f%f%f%s');
LatEpic=-41.73; 
LonEpic=174.15; 
depth = 8;

N=(y-LatEpic)*pi*6400/180;
E=(x-LonEpic)*pi*cos(LatEpic*pi/180)*6400/180; 
[uE,uN,uZ] = okada85(E,N,depth,strike,dip,width,width,rake,slip,open);