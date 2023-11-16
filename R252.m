%% R252 (robot) summoning
clear all;
% figureHandle = figure;

%% Set Axis and base (so it can be moved)
kV = [0, 0, 0]; % Array that aligns the origin of the whole setup
brickCount = 2;
smoothAni = 20; % Speed of steps for animation (DON'T go over 50)

workspace = [-6, 6, -6, 6, 0, 6]; % Define the workspace dimensions

Environment

% Add the robot and set its base transformation
baseTR = transl([kV(1)+0.5, kV(2)+4.3, kV(3)+1.75]);
UR3 = LinearUR3(baseTR);
% UR3.PlotAndColourRobot(figureHandle);
hold on;

% Adding 2nd robot
h_1 = PlaceObject('Arm90.ply', [-4,1.75,-3.5]);
verts = [get(h_1,'Vertices'), ones(size(get(h_1,'Vertices'),1),1)] * trotx(-pi/2);
verts(:,1) = verts(:,1);
set(h_1,'Vertices',verts(:,1:3))

% baseTR_2 = transl([kV(1)-4, kV(2)+2, kV(3)+1.75]);
% P90 = Pulse90v2(baseTR_2);
% P90.PlotAndColourRobot(figureHandle);
% hold on;

pointCloud(UR3)

%% Initialising the UR3 and Bricks + Animation

% The inital brick positions
brickU = cell(1,6);
brickU{1} = transl(-1+kV(1),4.2+kV(2),1.9+kV(3))* trotx(pi);
brickU{2} = transl(-1+kV(1),4.3+kV(2),1.9+kV(3))* trotx(pi);
brickU{3} = transl(-1+kV(1),4.4+kV(2),1.9+kV(3))* trotx(pi);
brickU{4} = transl(-1+kV(1),4.5+kV(2),1.9+kV(3))* trotx(pi);
brickU{5} = transl(-1+kV(1),4.6+kV(2),1.9+kV(3))* trotx(pi);
brickU{6} = transl(-1+kV(1),4.7+kV(2),1.9+kV(3))* trotx(pi);

% The final brick positions
brickV = cell(1,6);
brickV{1} = transl(1+kV(1),4.5+kV(2),1.75+kV(3))* trotx(-pi/2);
brickV{2} = transl(1+kV(1),4.5+kV(2),1.76+kV(3))* trotx(-pi/2);
brickV{3} = transl(1+kV(1),4.5+kV(2),1.77+kV(3))* trotx(-pi/2);
brickV{4} = transl(1+kV(1),4.5+kV(2),1.78+kV(3))* trotx(-pi/2);
brickV{5} = transl(1+kV(1),4.5+kV(2),1.79+kV(3))* trotx(-pi/2);
brickV{6} = transl(1+kV(1),4.5+kV(2),1.8+kV(3))* trotx(-pi/2);

BrickHerdCall = BrickHerd(6,brickU);

% Animating the joints from q values
% (ie Calculate joint configurations for the brick positions)
qBrickU = ikBrick(UR3,brickU); % inverse kinematics calcluations (initial position)
qBrickV = ikBrick(UR3,brickV); % inverse kinematics calcluations (final positon)

% Animate the joints of the robot to move the
% bricks from initial to final positions
movingBricks(UR3, qBrickU, qBrickV, BrickHerdCall, smoothAni) % Intialising animations

% Function to calculate joint configurations for brick positions
function brickMat = ikBrick(robot,positionBrick)
brickMat = cell(1,6);

for i = 1:6 % 9 bricks
    aniEndEffect = positionBrick{i};
    brickMat{i} = robot.model.ikcon(aniEndEffect);
    %ikcon takes the joint limits but ikine doesn't
    %ikcon is used because the prasmatic joint has negative joint limits
end

end

%% Robot brick

% Function to animate the robot and bricks
function movingBricks(robot, qBrickU, qBrickV, BrickHerdCall, smoothAni)
for h = 1:6
    q1 = robot.model.getpos();
    q1 = jtraj(q1,qBrickU{h},smoothAni);
    brickMat = q1;

    for j = 1:length(brickMat)
        robot.model.animate(brickMat(j,:))
        drawnow(); %mapping out movement of links
    end

    q1 = robot.model.getpos()
    position = robot.model.fkine(q1)

    % Brick positions
    ActualPos = BrickHerdCall.cowModel{h}.base.t
    pause(0.25)

    q2 = jtraj(q1,qBrickV{h},smoothAni);

    for k = 1:length(q2)
        robot.model.animate(q2(k,:));
        drawnow(); 

        % End effector animation
        endKine = robot.model.fkine(robot.model.getpos());

        BrickHerdCall.cowModel{h}.base = endKine.T;
        BrickHerdCall.cowModel{h}.animate(0);
        drawnow()

    end
    pause(0);

end
end

%% Point Cloud
function pointCloud(robot)
stepRads = deg2rad(45);
qlim = robot.model.qlim;
pointCloudeSize = prod(floor((qlim(1:7,2)-qlim(1:7,1))/stepRads + 1));
pointCloud = zeros(pointCloudeSize,3);
counter = 1;
tic
for q1 = qlim(1,1):stepRads:qlim(1,2)
    for q2 = qlim(2,1):stepRads:qlim(2,2)
        for q3 = qlim(3,1):stepRads:qlim(3,2)
            for q4 = qlim(4,1):stepRads:qlim(4,2)
                for q5 = qlim(5,1):stepRads:qlim(5,2)
                    for q6 = qlim(6,1):stepRads:qlim(6,2)
                        % joint 6 dw assume 0
                        q7 = 0;
                        %for q6 = qlim(6,1):stepRads:qlim(6,2)
                        q = [q1,q2,q3,q4,q5,q6,q7];
                        tr = robot.model.fkineUTS(q);
                        pointCloud(counter,:) = tr(1:3,4)';
                        counter = counter + 1;
                        if mod(counter/pointCloudeSize * 100,1) == 0
                            disp(['After ',num2str(toc),' seconds, completed ',num2str(counter/pointCloudeSize * 100),'% of poses']);
                        end
                        %                     end
                    end
                end
            end
        end
    end
end

%%Create a 3D model showing where the end effector can be over all these samples.
% plot3(pointCloud(:,1),pointCloud(:,2),pointCloud(:,3),'r.');
end
