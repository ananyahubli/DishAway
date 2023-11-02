%% Environment
<<<<<<< Updated upstream

%% Clear the workspace
clear;
clc;
clf;

%% Set Axis and base (so it can be moved)
kV = [0, 0, 0]; % Array that aligns the origin of the whole setup
axis ([-6 6 -6 6 0 6]);

%% Run these in order
Enviro(kV)
baseTR = transl([kV(1)+0.5, kV(2)+4.3, kV(3)+1.75]);
UR3 = LinearUR3(baseTR);


%% Create environment

% Function to create the environment
function Enviro(kV)

%Create the concrete floor
surf([-6 + kV(1),-6 + kV(1);6 + kV(1), 6 + kV(1)] ...
    ,[-6 + kV(2),6 + kV(2);-6 + kV(2), 6 + kV(2)] ...
    ,[0.01 + kV(3), 0.01 + kV(3); 0.01 + kV(3), 0.01 + kV(3)] ...
    ,'CData',imread('concrete.jpg') ...
    ,'FaceColor','texturemap');
hold on;

PlaceObject('Kitchen.ply',[kV(1)-2, kV(2)+4, kV(3)+0]);
PlaceObject('plate_standing.ply',[kV(1)-1, kV(2)+4.2, kV(3)+1.9]);

view(3);

% %% Optional lighting for better visualization
light('Position', [0, 0, 2], 'Style', 'local');
light('Position', [0, 0, -2], 'Style', 'local');
end

%% Environment.Ananyatest
% 
% % Environment
% 
% %% Clear the workspace
% clear;
% clc;
% clf;
% 
% %% Set Axis and base (so it can be moved)
% kV = [0, 0, 0]; % Array that aligns the origin of the whole setup
% axis ([-6 6 -6 6 0 6]);
% %% Run these in order
% Enviro(kV)
% 
% %% Create environment
% 
% % Function to create the environment
% function Enviro(kV)
% 
% %Create the concrete floor
% surf([-6 + kV(1),-6 + kV(1);6 + kV(1), 6 + kV(1)] ...
%     ,[-6 + kV(2),6 + kV(2);-6 + kV(2), 6 + kV(2)] ...
%     ,[0.01 + kV(3), 0.01 + kV(3); 0.01 + kV(3), 0.01 + kV(3)] ...
%     ,'CData',imread('concrete.jpg') ...
%     ,'FaceColor','texturemap');
% hold on;
% 
% PlaceObject('Kitchen.ply',[kV(1)-2, kV(2)+4, kV(3)+0]);
% 
% view(2);
% %view(3);
% 
% % %% Optional lighting for better visualization
% light('Position', [0, 0, 2], 'Style', 'local');
% light('Position', [0, 0, -2], 'Style', 'local');
% end
% 
% % %% Environment.Ananyatest
% >>>>>>> 48ee822f9b0c3824178b544a3aa8b76332e785ab
% % 
% % % Load up the enviroment 
% % 
% % clear all
% % hold on 
% % axis equal 
% % 
% % 
% % surf([-5,5;-5,5] ...
% % ,[5,5;-5,-5] ...
% % ,[0,0;0,0] ...
% % ,'CData',imread('concrete.jpg') ...
% % ,'FaceColor','texturemap');
% % 
% <<<<<<< HEAD
% % h_1 = PlaceObject('Kitchen.ply',[0,2,0.9]);
% % verts = [get(h_1,'Vertices'), ones(size(get(h_1,'Vertices'),1),1)];
% % verts(:,1) = verts(:,1);
% % set(h_1,'Vertices',verts(:,1:3))
% =======
% % h_1 = PlaceObject('Kitchen.PLY',[0,2,0.9]);
% % verts = [get(h_1,'Vertices'), ones(size(get(h_1,'Vertices'),1),1)];
% % verts(:,1) = verts(:,1);
% % set(h_1,'Vertices',verts(:,1:3))
% 
% >>>>>>> 48ee822f9b0c3824178b544a3aa8b76332e785ab
=======
>>>>>>> Stashed changes
