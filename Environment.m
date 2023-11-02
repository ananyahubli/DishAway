%% Environment

% %% Clear the workspace
% clear;
% clc;
% clf;
%
% %% Set Axis and base (so it can be moved)
% kV = [0, 0, 0]; % Array that aligns the origin of the whole setup
% axis ([-6 6 -6 6 0 6]);
%
% %% Run these in order
% Enviro(kV)
% baseTR = transl([kV(1)+0.5, kV(2)+4.3, kV(3)+1.75]);
% UR3 = LinearUR3(baseTR);
%
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
% PlaceObject('plate_standing.ply',[kV(1)-1, kV(2)+4.2, kV(3)+1.9]);
%
% view(3);
%
% % %% Optional lighting for better visualization
% light('Position', [0, 0, 2], 'Style', 'local');
% light('Position', [0, 0, -2], 'Style', 'local');
% end

classdef Environment < handle
    properties
        % kV % Array that aligns the origin of the whole setup
    end

    methods
        % function obj = Environment()
        %     % Constructor
        %     kV = [0, 0, 0];
        % end

        % function self = Environment()
        %     kV = [0, 0, 0];
        %     % Create the environment
        %     % Create the concrete floor
        %     surf([-6 + kV(1), 6 + kV(1); 6 + kV(1), 6 + kV(1)], ...
        %         [-6 + kV(2), 6 + kV(2); -6 + kV(2), 6 + kV(2)], ...
        %         [0.01 + kV(3), 0.01 + kV(3); 0.01 + kV(3), 0.01 + kV(3)], ...
        %         'CData', imread('concrete.jpg'), ...
        %         'FaceColor', 'texturemap');
        %     hold on;
        % 
        %     placeObject('Kitchen.ply', [-2, 4, 0]);
        %     placeObject('plate_standing.ply', [-1, 4.2, 1.9]);
        % 
        %     view(3);
        % 
        %     % Optional lighting for better visualization
        %     light('Position', [0, 0, 2], 'Style', 'local');
        %     light('Position', [0, 0, -2], 'Style', 'local');
        % end

        function self = Environment()
            disp('Setting up environment');

            % insert robot
            %self.robot = LinearUR3(transl(1,4.5,1.7));
            % hold on;
            %axis ([-6 6 -2 6 0 6]);

            %Nour Environment
            kV = [0, 0, 0];

            surf([-6 + kV(1),-6 + kV(1);6 + kV(1), 6 + kV(1)] ...
                ,[-2 + kV(2),6 + kV(2);-2 + kV(2), 6 + kV(2)] ...
                ,[0.01 + kV(3), 0.01 + kV(3); 0.01 + kV(3), 0.01 + kV(3)] ...
                ,'CData',imread('concrete.jpg') ...
                ,'FaceColor','texturemap');
            hold on;

            PlaceObject('Kitchen.ply',[kV(1)-2, kV(2)+4, kV(3)+0]);
            PlaceObject('plate_standing.ply', [-1, 4.2, 1.9]);

            view(2);
            %view(3);

            % %% Optional lighting for better visualization
            light('Position', [0, 0, 2], 'Style', 'local');
            light('Position', [0, 0, -2], 'Style', 'local');

            % % insert environment
            % self.sponge = Sponge();
            % self.plate = Plate();
            %
            % show = false;
            % self.enviro = Environment(-0.02,0.14,-0.045,'dirtyplates.ply', show, 0.13, 0.18);
            % self.enviro = Environment(-0.02,-0.15,-0.045,'cleanplates.ply', show, 0.13, 0.18);
            % self.enviro = Environment(0,-0.06,-0.28,'enviro.ply', show, 0.9, 0.77);

            % %camlight;

            % set initial positions
            % qStart = ([0,0,0,0,0,0,0]);
            % self.robot.model.animate(qStart);
            % self.plate.MovePlate(transl(-0.02,0.14,0.075)*trotx(pi));
            % self.sponge.MoveSponge(transl(0.15,0.07,0.06)*trotx(pi));

            % initialise visual servoing
            %self.retreat = RobotRetreat();
        end

    end
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
