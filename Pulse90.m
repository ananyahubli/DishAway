%% Pulse 90 Summoning

%% Set Axis and base (so it can be moved)
kV = [0, 0, 0]; % Array that aligns the origin of the whole setup
PlateCount = 6;
Animation = 20; % Speed of steps for animation (DON'T go over 50)

workspace = [-6, 6, -6, 6, 0, 6]; % Define the workspace dim ensions

% Add the robot and set its base transformation
baseTR = transl([kV(1)+0.5, kV(2)+4.3, kV(3)+1.75]);

Link0 = pcread("Rozum0.ply");
