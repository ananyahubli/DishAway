% %% Environment
% %% Clear the workspace
% clear;
% clc;
% clf;
%
% %% Set Axis and base (so it can be moved)
% kV = [0, 0, 0]; % Array that aligns the origin of the whole setup
% %% Run these in order
% PlaceObject()
% Enviro(kV)
%
% %% Create environment
%
% function PlaceObject(objectFile, position, color)
%     % Load the PLY object
%     plyObject = pcread(objectFile);
%
%     % Assign a color to the object
%     plyObject.Color = color;
%
%     % Translate the object to the desired position
%     plyObject = pctransform(plyObject, affine3d([1, 0, 0, position(1); 0, 1, 0, position(2); 0, 0, 1, position(3); 0, 0, 0, 1]));
%
%     % Display the object
%     pcshow(plyObject);
% end
%
% % Function to create the environment
% function Enviro(kV)
%
% %Create the concrete floor
% surf([-3.5 + kV(1),-3.5 + kV(1);3.5 + kV(1), 3.5 + kV(1)] ...
%     ,[-3.5 + kV(2),3.5 + kV(2);-3.5 + kV(2), 3.5 + kV(2)] ...
%     ,[0.01 + kV(3), 0.01 + kV(3); 0.01 + kV(3), 0.01 + kV(3)] ...
%     ,'CData',imread('concrete.jpg') ...
%     ,'FaceColor','texturemap');
% hold on;
%
% PlaceObject('KitchenEnviro.ply',[kV(1), kV(2), kV(3)], [1 0 0]); % Red color
% % PlaceObject('kuhnja.ply',[kV(1), kV(2), kV(3)]);
%
% %view(2);
% view(3);
%
% % %% Optional lighting for better visualization
% light('Position', [0, 0, 2], 'Style', 'local');
% light('Position', [0, 0, -2], 'Style', 'local');
% end

%% Environment
%% Clear the workspace
clear;
clc;
clf;

%% Set Axis and base (so it can be moved)
kV = [0, 0, 0]; % Array that aligns the origin of the whole setup

%% Run these in order
PlaceObject('KitchenEnviro.ply', [kV(1), kV(2), kV(3)], [1 0 0]); % Call PlaceObject with proper arguments
Enviro(kV)

%% Create environment

function PlaceObject(objectFile, position, color)
% Load the PLY object
plyObject = pcread(objectFile);

% Assign a color to the object
plyObject.Color = color;

% Translate the object to the desired position
plyObject = pctransform(plyObject, affine3d([1, 0, 0, position(1); 0, 1, 0, position(2); 0, 0, 1, position(3); 0, 0, 0, 1]));

% Display the object
pcshow(plyObject);
end

% Function to create the environment
function Enviro(kV)

%Create the concrete floor
surf([-10 + kV(1),-10 + kV(1);10 + kV(1), 10 + kV(1)] ...
    ,[-10 + kV(2),10 + kV(2);-10 + kV(2), 10 + kV(2)] ...
    ,[0.01 + kV(3), 0.01 + kV(3); 0.01 + kV(3), 0.01 + kV(3)] ...
    ,'CData',imread('concrete.jpg') ...
    ,'FaceColor','texturemap');
hold on;

%view(2);
view(3);

% %% Optional lighting for better visualization
light('Position', [0, 0, 2], 'Style', 'local');
light('Position', [0, 0, -2], 'Style', 'local');
end
