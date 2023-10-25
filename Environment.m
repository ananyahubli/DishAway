%% Environment

% %% Clear the workspace
% clear;
% clc;
% clf;
% 
% %% Set Axis and base (so it can be moved)
% kV = [0, 0, 0]; % Array that aligns the origin of the whole setup
% %% Run these in order
% Enviro(kV)
% 
% %% Create environment
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
% PlaceObject('KitchenEnviro',[kV(1), kV(2), kV(3)]);
% 
% view(2);
% %view(3);
% 
% % %% Optional lighting for better visualization
% light('Position', [0, 0, 2], 'Style', 'local');
% light('Position', [0, 0, -2], 'Style', 'local');
% end

%% Environment.Ananyatest

% Load up the enviroment 

clear all
hold on 
axis equal 


surf([-5,5;-5,5] ...
,[5,5;-5,-5] ...
,[0,0;0,0] ...
,'CData',imread('concrete.jpg') ...
,'FaceColor','texturemap');

h_1 = PlaceObject('Kitchen.PLY',[0,2,0.9]);
verts = [get(h_1,'Vertices'), ones(size(get(h_1,'Vertices'),1),1)];
verts(:,1) = verts(:,1);
set(h_1,'Vertices',verts(:,1:3))
