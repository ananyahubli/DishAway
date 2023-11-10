%% yo 

%% Ananya Test 

%% Akshayan Test 

%%

%% Create a Pulse90v2 robot with the default base transformation

robot = Pulse90v2();

% Test joint movement
robot.TestMoveJoints();

% %% 
% clear all;
% kV = [0, 0, 0];
% %% Create Pulse90v2 robot
% pulseRobot = Pulse90v2();
% smoothAni = 20;
% 
% bU = transl(-1 + kV(1), 4.2 + kV(2), 1.9 + kV(3)) * trotx(pi);
% bV = transl(1 + kV(1), 4.5 + kV(2), 1.75 + kV(3)) * trotx(-pi/2);
% 
% % Assuming 'ikPulse90v2' is the inverse kinematics function for Pulse90v2
% qbU = ikPulse90v2(pulseRobot, bU);
% qbV = ikPulse90v2(pulseRobot, bV);
% 
% 
% movingBricks(pulseRobot, qbU, qbV, smoothAni);  % Call the movingBricks function to animate
% 
% q1 = pulseRobot.model.getpos();
% position = pulseRobot.model.fkine(q1);
% 
% q2 = jtraj(q1, qbV, smoothAni);  % Generate a trajectory from qbU to qbV
% pulseRobot.animate(q2);  % Animate the robot along the trajectory
% 


% % Define pick and place joint angles
% % Example joint angles for pick and place
% pickJointAngles = [0, 0, 0, 0, 0, 0];  % Replace these with the actual joint angles
% placeJointAngles = [1.2, 0.5, -0.3, 0.8, 1.5, -2.1];  % Replace these with the actual joint angles
% 
% jtraj(q1,qbU{h},smoothAni);
% pulseRobot.model.animate(q2(k,:));
% 
% % Move to pick joint angles
% pulseRobot.model.animate(pickJointAngles);
% 
% % Move to place joint angles
% pulseRobot.model.animate(placeJointAngles);
