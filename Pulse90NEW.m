%% Pulse 90 Summoning

classdef Pulse90NEW < RobotBaseClass
    %% Pulse90

    properties(Access = public)
        plyFileNameStem = 'Pulse90NEW';
    end

    methods
        %% Define robot Function
        function self = Pulse90NEW(baseTr)
            self.CreateModel();
            if nargin < 1
                baseTr = eye(4);
            end
            self.model.base = self.model.base.T * baseTr * trotx(pi/2) * troty(pi/2);
            self.PlotAndColourRobot();
        end

        %% Create the robot model
        function CreateModel(self)

            % Create the model mounted on a linear rail
            link(1) = Link([pi     0         0         pi/2    1]); % PRISMATIC Link
            link(2) = Link([0      0.1519    0         pi/2    0]);
            link(3) = Link([0      0         -0.24365  0       0]);
            link(4) = Link([0      0         -0.21325  0       0]);
            link(5) = Link([0      0.11235   0         pi/2    0]);
            link(6) = Link([0      0.08535   0         -pi/2   0]);
            link(7) = Link([0      0.0819    0         0       0]);

            % Incorporate joint limits
            link(1).qlim = [-0.8 -0.01];
            link(2).qlim = [-360 360]*pi/180;
            link(3).qlim = [-90 90]*pi/180;
            link(4).qlim = [-170 170]*pi/180;
            link(5).qlim = [-360 360]*pi/180;
            link(6).qlim = [-360 360]*pi/180;
            link(7).qlim = [-360 360]*pi/180;

            self.model = SerialLink(link,'name',self.name);
        end
    end
end