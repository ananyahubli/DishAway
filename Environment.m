%% Environment
classdef Environment < handle
    properties
    end
    methods
        function self = Environment()
            disp('Setting up environment');
            kV = [0, 0, 0];
            surf([-6 + kV(1),-6 + kV(1);6 + kV(1), 6 + kV(1)] ...
                ,[-2 + kV(2),6 + kV(2);-2 + kV(2), 6 + kV(2)] ...
                ,[0.01 + kV(3), 0.01 + kV(3); 0.01 + kV(3), 0.01 + kV(3)] ...
                ,'CData',imread('concrete.jpg') ...
                ,'FaceColor','texturemap');
            hold on;
            PlaceObject('Kitchen.ply',[kV(1)-2, kV(2)+4, kV(3)+0]);
            PlaceObject('eStop.ply',[0,-0.46,1.7]);
            PlaceObject('fireExtinguisherElevated.ply',[-4,-0.8,0.5]);
            PlaceObject('female.ply',[1.4,-1,0]);
            %PlaceObject('plate_standing.ply', [-1, 4.2, 1.9]);
            %view(2);
            view(3);
            % %% Optional lighting for better visualization
            light('Position', [0, 0, 2], 'Style', 'local');
            light('Position', [0, 0, -2], 'Style', 'local');
        end
    end
end