% ENGSCI263 
% LAB 1 - Ad-hoc Earthquake Calibration
% For further information, refer to lab1_instructions.pdf

%% TASK 1 - Familiarization

% current working directory
Path = pwd;     

% Initial parameter values
strike = 40.;    % °     Allowed interval: [0 - 360]
length = 7.5;    % km    Allowed interval: [0 - 20]

% Run Okada model for selected parameters and plot result
PlotH0(strike, length, Path);

%% TASK 2 - Ad-hoc calibration

% Choose new parameter values
strike = 239.48;    % °     Allowed interval: [0 - 360]
length = 14.9625;    % km    Allowed interval: [0 - 20]

% Run Okada model for new parameters and compare result with previous
PlotH(strike, length, Path)
    
%% TASK 3 - Visualising calibration

% Plot objective function over parameter space with calibration path
MapCalibration(Path);

%% TASK 4 - Magnitude calculation

Mw = 2/3 * log10(30e9 * (14.9625e3)^2 * 1.7) - 6;

disp(num2str(Mw));








