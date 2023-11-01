%% R252 (robot) summoning

%% Set Axis and base (so it can be moved)
kV = [0, 0, 0]; % Array that aligns the origin of the whole setup
brickCount = 6;
smoothAni = 20; % Speed of steps for animation (DON'T go over 50)

workspace = [-6, 6, -6, 6, 0, 6]; % Define the workspace dimensions

% Add the robot and set its base transformation
baseTR = transl([kV(1), kV(2), kV(3)+0.5]);
% Uri = LinearUR3(baseTR);
UR3 = LinearUR3(baseTR);

pointCloud(UR3)

%% Initialising the UR3 and Bricks + Animation

% The inital brick positions
brickU = cell(1,6);
brickU{1} = transl(-0.89+kV(1),-0.31+kV(2),0.543+kV(3))* trotx(pi);
brickU{2} = transl(-0.79+kV(1),-0.40+kV(2),0.543+kV(3))* trotx(pi);
brickU{3} = transl(-0.69+kV(1),-0.36+kV(2),0.543+kV(3))* trotx(pi);
brickU{4} = transl(-0.59+kV(1),-0.36+kV(2),0.543+kV(3))* trotx(pi);
brickU{5} = transl(-0.60+kV(1),-0.26+kV(2),0.563+kV(3))* trotx(pi);
brickU{6} = transl(-0.39+kV(1),-0.36+kV(2),0.543+kV(3))* trotx(pi);

% The final brick positions
brickV = cell(1,6);
brickV{1} = transl(-0.2  +kV(1),0.449+kV(2),0.543+kV(3))* trotx(pi)*trotz(pi/2);
brickV{2} = transl(-0.334+kV(1),0.449+kV(2),0.543+kV(3))* trotx(pi)*trotz(pi/2);
brickV{3} = transl(-0.469 +kV(1),0.449+kV(2),0.543+kV(3))* trotx(pi)*trotz(pi/2);
brickV{4} = transl(-0.2  +kV(1),0.449+kV(2),0.0341+0.543+kV(3))* trotx(pi)*trotz(pi/2);
brickV{5} = transl(-0.334+kV(1),0.449+kV(2),0.0341+0.543+kV(3))* trotx(pi)*trotz(pi/2);
brickV{6} = transl(-0.469 +kV(1),0.449+kV(2),0.0341+0.543+kV(3))* trotx(pi)*trotz(pi/2);

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









%% Ikcon example code
% 
% r = EV6-900 % call in robot
% 
% exampleTR = transl(0.1,0.2,0.5); % set the location you want
% 
% q = r.model.ikcon(exampleTR); % get the joint values
% 
% steps = 50; % framerate
% 
% q0 = r.model.getpos();
% 
% qMatrix = jtraj(q0,q,steps);
% 
% for i = 1:length(qMatrix)
% 
%     r.model.animate(qMatrix(i,:)); % animate
% 
%     drawnow();
% 
% end

