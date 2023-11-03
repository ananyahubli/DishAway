%% Initial robot code

%% Clear the workspace
clear;
clc;
clf;

%% Set Axis and base (so it can be moved)
kV = [0, 0, 0]; % Array that aligns the origin of the whole setup
brickCount = 9;
smoothAni = 20; % Speed of steps for animation (DON'T go over 50)

workspace = [-3.5, 3.5, -3.5, 3.5, 0, 3]; % Define the workspace dimensions

% Add the robot and set its base transformation
baseTR = transl([kV(1), kV(2), kV(3)+0.5]);
Uri = LinearUR3(baseTR);

%% Initialising the UR3 and Bricks + Animation

% The inital brick positions
brickU = cell(1,9);
brickU{1} = transl(-0.89+kV(1),-0.31+kV(2),0.543+kV(3))* trotx(pi);
brickU{2} = transl(-0.79+kV(1),-0.40+kV(2),0.543+kV(3))* trotx(pi);
brickU{3} = transl(-0.69+kV(1),-0.36+kV(2),0.543+kV(3))* trotx(pi);
brickU{4} = transl(-0.59+kV(1),-0.36+kV(2),0.543+kV(3))* trotx(pi);
brickU{5} = transl(-0.60+kV(1),-0.26+kV(2),0.563+kV(3))* trotx(pi);
brickU{6} = transl(-0.39+kV(1),-0.36+kV(2),0.543+kV(3))* trotx(pi);
brickU{7} = transl(-0.29+kV(1),-0.36+kV(2),0.543+kV(3))* trotx(pi);
brickU{8} = transl(-0.19+kV(1),-0.36+kV(2),0.543+kV(3))* trotx(pi);
brickU{9} = transl(-0.09+kV(1),-0.36+kV(2),0.546+kV(3))* trotx(pi);

% The final brick positions
brickV = cell(1,9);
brickV{1} = transl(-0.2  +kV(1),0.449+kV(2),0.543+kV(3))* trotx(pi)*trotz(pi/2);
brickV{2} = transl(-0.334+kV(1),0.449+kV(2),0.543+kV(3))* trotx(pi)*trotz(pi/2);
brickV{3} = transl(-0.469 +kV(1),0.449+kV(2),0.543+kV(3))* trotx(pi)*trotz(pi/2);
brickV{4} = transl(-0.2  +kV(1),0.449+kV(2),0.0341+0.543+kV(3))* trotx(pi)*trotz(pi/2);
brickV{5} = transl(-0.334+kV(1),0.449+kV(2),0.0341+0.543+kV(3))* trotx(pi)*trotz(pi/2);
brickV{6} = transl(-0.469 +kV(1),0.449+kV(2),0.0341+0.543+kV(3))* trotx(pi)*trotz(pi/2);
brickV{7} = transl(-0.2  +kV(1),0.449+kV(2),0.0341+0.0341+0.543+kV(3))* trotx(pi)*trotz(pi/2);
brickV{8} = transl(-0.334+kV(1),0.449+kV(2),0.0341+0.0341+0.543+kV(3))* trotx(pi)*trotz(pi/2);
brickV{9} = transl(-0.469 +kV(1),0.449+kV(2),0.0341+0.0341+0.543+kV(3))* trotx(pi)*trotz(pi/2);

BrickHerdCall = BrickHerd(9,brickU);

% Animating the joints from q values (ie Calculate joint
% configurations for the brick positions)
qBrickU = ikBrick(Uri,brickU); % inverse kinematics calcluations (initial position)
qBrickV = ikBrick(Uri,brickV); % inverse kinematics calcluations (final positon)

% Animate the joints of the robot to move the
% bricks from initial to final positions
movingBricks(Uri, qBrickU, qBrickV, BrickHerdCall, smoothAni) % Intialising animations

% Function to calculate joint configurations for brick positions
function brickMat = ikBrick(robot,positionBrick)
brickMat = cell(1,9);

for i = 1:9 % 9 bricks
    aniEndEffect = positionBrick{i};
    brickMat{i} = robot.model.ikcon(aniEndEffect);
    %ikcon takes the joint limits but ikine doesn't
    %ikcon is used because the prasmatic joint has negative joint limits
end

end

%% Robot brick

% Function to animate the robot and bricks
function movingBricks(robot, qBrickU, qBrickV, BrickHerdCall, smoothAni)
for h = 1:9
    q1 = robot.model.getpos();
    q1 = jtraj(q1,qBrickU{h},smoothAni);
    brickMat = q1;

    for j = 1:length(brickMat)
        robot.model.animate(brickMat(j,:))
        drawnow();
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