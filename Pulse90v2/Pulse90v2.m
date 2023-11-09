classdef Pulse90v2 < RobotBaseClass

    properties(Access = public)
        plyFileNameStem = 'Pulse90v2';
    end

    methods
        %% Define robot Function
        function self = Pulse90v2(baseTr)
            self.CreateModel();
            if nargin < 1
                baseTr = eye(4);
            end
            self.model.base = self.model.base.T * baseTr * trotx(pi/2) * troty(pi/2);
            self.PlotAndColourRobot();

        end

        function PlotAndColourRobot(self)
            home_position = [0 0 0 0 0 0];  % Adjust these values to represent the home position
            self.model.plot(home_position, 'workspace', [-1 1 -1 1 -1 1], 'tilesize', 0.1, 'floorlevel', -0.5);
        end


        %% Create the robot model
        function CreateModel(self)
            link(1) = Link('d', 0.2325, 'a', 0, 'alpha', pi/2, 'qlim', deg2rad([-360 360]), 'offset', 0);
            link(2) = Link('d', 0, 'a', -0.450, 'alpha', 0, 'qlim', deg2rad([-360 360]), 'offset', 0);
            link(3) = Link('d', 0, 'a', -0.370, 'alpha', 0, 'qlim', deg2rad([-360 360]), 'offset', 0);
            link(4) = Link('d', 0.1205, 'a', 0, 'alpha', pi/2, 'qlim', deg2rad([-360 360]), 'offset', 0);
            link(5) = Link('d', 0.1711, 'a', 0, 'alpha', -pi/2, 'qlim', deg2rad([-360,360]), 'offset', 0);
            link(6) = Link('d', 0.1226, 'a', 0, 'alpha', 0, 'qlim', deg2rad([-360,360]), 'offset', 0);

            % Joint limits
            link(1).qlim = [-360 360]*pi/180;
            link(2).qlim = [-90 90]*pi/180;
            link(3).qlim = [-170 170]*pi/180;
            link(4).qlim = [-360 360]*pi/180;
            link(5).qlim = [-360 360]*pi/180;
            link(6).qlim = [-360 360]*pi/180;

            % link(2).offset = -pi/2;
            % link(4).offset = -pi/2;

            self.model = SerialLink(link, 'name', self.name);
        end

    end
end