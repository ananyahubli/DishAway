%SMARTTEACH Seriallink Graphical teach "pendant"
%
% R.smartTeach(Q, OPTIONS) allows the user to "drive" a graphical robot by means
% of a graphical slider panel. If no graphical robot exists one is created
% in a new window.  Otherwise all current instances of the graphical robot
% are driven.  The robots are set to the initial joint angles Q.
%
% R.smartTeach(OPTIONS) as above but with options and the initial joint angles
% are taken from the pose of an existing graphical robot, or if that doesn't
% exist then zero.
%
% Options::
% 'eul'           Display tool orientation in Euler angles (default)
% 'rpy'           Display tool orientation in roll/pitch/yaw angles
% 'approach'      Display tool orientation as approach vector (z-axis)
% '[no]deg'       Display angles in degrees (default true)
% 'callback',CB   Set a callback function, called with robot object and
%                 joint angle vector: CB(R, Q)
%
% Example::
%
% To display the velocity ellipsoid for a Puma 560
%
%        p560.teach('callback', @(r,q) r.vellipse(q));
%
% GUI::
%
% - The specified callback function is invoked every time the joint configuration changes.
%   the joint coordinate vector.
% - The Quit (red X) button destroys the teach window.
%
% Notes::
% - If the robot is displayed in several windows, only one has the
%   teach panel added.
% - The slider limits are derived from the joint limit properties.  If not
%   set then for
%   - a revolute joint they are assumed to be [-pi, +pi]
%   - a prismatic joint they are assumed unknown and an error occurs.
%
% See also SerialLink.plot and SerialLink.teach

function smartTeach(robot, varargin)

%-------------------------------
% parameters for teach panel
bgcol = [0.78 0.76 0.93];  % background color

height = 0.06;  % height of slider rows
%-------------------------------

%---- handle options
opt.deg = true;
opt.orientation = {'rpy', 'eul', 'approach'};
opt.callback = [];
[opt,args] = tb_optparse(opt, varargin);
opt.mode = {'xyz', 'joints'}; %% additional

% stash some options into the persistent object
handles.orientation = opt.orientation;
handles.callback = opt.callback;
handles.opt = opt;
handles.mode = opt.mode; %% additional

qlim = robot.model.qlim;

% we need to have qlim set to finite values for a prismatic joint
if any(isinf(qlim))
    error('RTB:teach:badarg', 'Must define joint coordinate limits for prismatic axes, set qlim properties for prismatic Links');
end

if isempty(args)
    q = [];
else
    q = args{1};
end

% set up scale factor, from actual limits in radians/metres to display units
qscale = ones(robot.model.n,1);
for j = 1:robot.model.n
    L = robot.model.links(j);
    if j == 1
        qscale(j) = qscale(j);
    else
    if opt.deg && L.isrevolute
        qscale(j) = 180/pi;
    end
    end
end
handles.qscale = qscale;
handles.robot = robot;

%---- install the panel at the side of the figure

% find the right figure to put it in
c = findobj(gca, 'Tag', robot.model.name); % check the current axes
if isempty(c)
    % doesn't exist in current axes, look wider
    c = findobj(0, 'Tag', robot.model.name);  % check all figures
    if isempty(c)
        % create robot in arbitrary pose
        robot.model.plot(zeros(1, robot.model.n));
        ax = gca;
    else
        ax = get(c(1), 'Parent');  % get first axis holding the robot
    end
else
    ax = gca;         % found it in current axes
end

handles.fig = get(ax, 'Parent');

% shrink the current axes to make room
%   [l b w h]
set(ax, 'Outerposition', [0.25 0 0.70 1]);

handles.curax = ax;

%create panel
panel = uipanel(handles.fig, ...
    'Title', 'DishAway~~', ...
    'BackGroundColor', bgcol, ...
    'Position', [0 0 0.25 1] ,'TitlePosition','centertop','FontName','courier');
set(panel, 'Units', 'pixels'); % stop automatic resizing
handles.panel = panel;
set(handles.fig, 'Units', 'pixels');

set(handles.fig, 'ResizeFcn', @(src,event) resize_callback(robot.model, handles));


%---- get the current robot state

if isempty(q)
    % check to see if there are any graphical robots of this name
    rhandles = findobj('Tag', robot.model.name);

    % find the graphical element of this name
    if isempty(rhandles)
        error('RTB:teach:badarg', 'No graphical robot of this name found');
    end
    % get the info from its Userdata
    info = get(rhandles(1), 'UserData');

    % the handle contains current joint angles (set by plot)
    if ~isempty(info.q)
        q = info.q;
    end
else
    robot.model.plot(q);
end
q = q;
handles.q = q;
T6 = robot.model.fkine(q).T;

%---- now make the sliders

%% XYZ sliders and edit boxes
xyz = transl(T6(1:3,4)');
xyzNames = ['x', 'y', 'z'];
rpyNames = ['r', 'p', 'y'];
n = 3;

for j = 1:n
    % slider label
    uicontrol(panel, 'Style', 'text', ...
        'Units', 'normalized', ...
        'BackgroundColor', bgcol, ...
        'Position', [0 height*(n - j + 2) 0.15 height], ...
        'FontUnits', 'normalized', ...
        'FontSize', 0.4, ...
        'String', sprintf('%c', xyzNames(1, j)));

    % slider itself
    % xyzLims = [[0.4 -1.3 1]; [1.6 0.7 2.1]];
    xyzLims = [[-0.8,-0.8,0]+robot.model.base.t';[1.6,0.8,1.1]+robot.model.base.t'];
    handles.slider(j) = uicontrol(panel, 'Style', 'slider', ...
        'Units', 'normalized', ...
        'Position', [0.15 height*(n - j + 2) 0.65 height], ...
        'Min', xyzLims(1, j), ...
        'Max', xyzLims(2, j), ...
        'Value', xyz(j, 1), ...
        'Tag', sprintf('Slider%c', xyzNames(1, j)));

    % text box showing slider value, also editable
    handles.edit(j) = uicontrol(panel, 'Style', 'edit', ...
        'Units', 'normalized', ...
        'Position', [0.80 height*(n - j + 2)+.01 0.20 0.9*height], ...
        'BackgroundColor', bgcol, ...
        'String', num2str(xyz(j, 1), 3), ...
        'HorizontalAlignment', 'left', ...
        'FontUnits', 'normalized', ...
        'FontSize', 0.3, ...
        'Tag', sprintf('Edit%c', xyzNames(1, j)));
end

%% Joint limit sliders and edit boxes

nR = robot.model.n;
for j = 1:nR
    % slider label
    uicontrol(panel, 'Style', 'text', ...
        'Units', 'normalized', ...
        'BackgroundColor', bgcol, ...
        'Position', [0 height*(nR - j + 5) 0.15 height], ...
        'FontUnits', 'normalized', ...
        'FontSize', 0.4, ...
        'String', sprintf('q%d', j));

    % slider itself
    q(j) = max( qlim(j,1), min( qlim(j,2), q(j) ) ); % clip to range
    handles.slider(j + 3) = uicontrol(panel, 'Style', 'slider', ...
        'Units', 'normalized', ...
        'Position', [0.15 height*(nR - j + 5) 0.65 height], ...
        'Min', qlim(j,1), ...
        'Max', qlim(j,2), ...
        'Value', q(j), ...
        'Tag', sprintf('Slider%d', j));

    % text box showing slider value, also editable
    handles.edit(j + 3) = uicontrol(panel, 'Style', 'edit', ...
        'Units', 'normalized', ...
        'Position', [0.80 height*(nR - j + 5)+.01 0.20 0.9*height], ...
        'BackgroundColor', bgcol, ...
        'String', num2str(qscale(j)*q(j), 5), ...
        'HorizontalAlignment', 'left', ...
        'FontUnits', 'normalized', ...
        'FontSize', 0.3, ...
        'Tag', sprintf('Edit%d', j));
end

%% Display Values

%---- set up the position display box
% X
uicontrol(panel, 'Style', 'text', ...
    'Units', 'normalized', ...
    'BackgroundColor', bgcol, ...
    'Position', [0.05 1-height 0.2 0.3*height], ...
    'FontUnits', 'normalized', ...
    'FontSize', 0.9, ...
    'HorizontalAlignment', 'left', ...
    'String', 'x:');

handles.t6.t(1) = uicontrol(panel, 'Style', 'text', ...
    'Units', 'normalized', ...
    'Position', [0.3 1-height 0.6 0.3*height], ...
    'FontUnits', 'normalized', ...
    'FontSize', 0.8, ...
    'String', sprintf('%.3f', T6(1, 4)), ...
    'Tag', 'T6');

% Y
uicontrol(panel, 'Style', 'text', ...
    'Units', 'normalized', ...
    'BackgroundColor', bgcol, ...
    'Position', [0.05 1-1.4*height 0.2 0.3*height], ...
    'FontUnits', 'normalized', ...
    'FontSize', 0.9, ...
    'HorizontalAlignment', 'left', ...
    'String', 'y:');

handles.t6.t(2) = uicontrol(panel, 'Style', 'text', ...
    'Units', 'normalized', ...
    'Position', [0.3 1-1.4*height 0.6 0.3*height], ...
    'FontUnits', 'normalized', ...
    'FontSize', 0.8, ...
    'String', sprintf('%.3f', T6(2, 4)));

% Z
uicontrol(panel, 'Style', 'text', ...
    'Units', 'normalized', ...
    'BackgroundColor', bgcol, ...
    'Position', [0.05 1-1.8*height 0.2 0.3*height], ...
    'FontUnits', 'normalized', ...
    'FontSize', 0.9, ...
    'HorizontalAlignment', 'left', ...
    'String', 'z:');

handles.t6.t(3) = uicontrol(panel, 'Style', 'text', ...
    'Units', 'normalized', ...
    'Position', [0.3 1-1.8* height 0.6 0.3*height], ...
    'FontUnits', 'normalized', ...
    'FontSize', 0.8, ...
    'String', sprintf('%.3f', T6(3, 4)));

% Orientation
switch opt.orientation
    case 'approach'
        labels = {'ax:', 'ay:', 'az:'};
    case 'eul'
        labels = {[char(hex2dec('3c6')) ':'], [char(hex2dec('3b8')) ':'], [char(hex2dec('3c8')) ':']}; % phi theta psi
    case'rpy'
        labels = {'R:', 'P:', 'Y:'};
end

%---- set up the orientation display box

% AX
uicontrol(panel, 'Style', 'text', ...
    'Units', 'normalized', ...
    'BackgroundColor', bgcol, ...
    'Position', [0.05 1-2.2*height 0.2 0.3*height], ...
    'FontUnits', 'normalized', ...
    'FontSize', 0.9, ...
    'HorizontalAlignment', 'left', ...
    'String', labels(1));

handles.t6.r(1) = uicontrol(panel, 'Style', 'text', ...
    'Units', 'normalized', ...
    'Position', [0.3 1-2.2*height 0.6 0.3*height], ...
    'FontUnits', 'normalized', ...
    'FontSize', 0.8, ...
    'String', sprintf('%.3f', T6(1, 3)));

% AY
uicontrol(panel, 'Style', 'text', ...
    'Units', 'normalized', ...
    'BackgroundColor', bgcol, ...
    'Position', [0.05 1-2.6*height 0.2 0.3*height], ...
    'FontUnits', 'normalized', ...
    'FontSize', 0.9, ...
    'HorizontalAlignment', 'left', ...
    'String', labels(2));

handles.t6.r(2) = uicontrol(panel, 'Style', 'text', ...
    'Units', 'normalized', ...
    'Position', [0.3 1-2.6*height 0.6 0.3*height], ...
    'FontUnits', 'normalized', ...
    'FontSize', 0.8, ...
    'String', sprintf('%.3f', T6(2, 3)));

% AZ
uicontrol(panel, 'Style', 'text', ...
    'Units', 'normalized', ...
    'BackgroundColor', bgcol, ...
    'Position', [0.05 1-3*height 0.2 0.3*height], ...
    'FontUnits', 'normalized', ...
    'FontSize', 0.9, ...
    'HorizontalAlignment', 'left', ...
    'String', labels(3));

handles.t6.r(3) = uicontrol(panel, 'Style', 'text', ...
    'Units', 'normalized', ...
    'Position', [0.3 1-3*height 0.6 0.3*height], ...
    'FontUnits', 'normalized', ...
    'FontSize', 0.8, ...
    'String', sprintf('%.3f', T6(3, 3)));

%% Callbacks and functionality
%---- add buttons
%Exit button
uicontrol(panel, 'Style', 'pushbutton', ...
    'Units', 'normalized', ...
    'Position', [0.80 height * (0) + 0.01 0.15 height], ...
    'FontUnits', 'normalized', ...
    'FontSize', 0.7, ...
    'CallBack', @(src,event) quit_callback(robot.model, handles), ...
    'BackgroundColor', 'white', ...
    'ForegroundColor', 'red', ...
    'String', 'X');

% the record button
handles.record = [];
if ~isempty(opt.callback)
    uicontrol(panel, 'Style', 'pushbutton', ...
        'Units', 'normalized', ...
        'Position', [0.1 height * (0) + 0.01 0.30 height], ...
        'FontUnits', 'normalized', ...
        'FontSize', 0.6, ...
        'CallBack', @(src,event) record_callback(robot.model, handles), ...
        'BackgroundColor', 'red', ...
        'ForegroundColor', 'white', ...
        'String', 'REC');
end

%---- now assign the callbacks
n = robot.model.n + 3;
for j = 1 : n
    % text edit box
    set(handles.edit(j), ...
        'Interruptible', 'off', ...
        'Callback', @(src,event)smartTeach_callback(src, robot.model.name, j, handles));

    % slider
    set(handles.slider(j), ...
        'Interruptible', 'off', ...
        'BusyAction', 'queue', ...
        'Callback', @(src,event)smartTeach_callback(src, robot.model.name, j, handles));
end
end


%% smartTeach Callback
function smartTeach_callback(src, name, j, handles)

% called on changes to a slider or to the edit box showing joint coordinate
%
% src      the object that caused the event
% name     name of the robot
% j        the joint index concerned (1..N)
% slider   true if the

qscale = 180/pi;
%find all graphical objects tagged with robot name
h = findobj('Tag', name);

%find graphical element with name h
if isempty(h)
    error('RTB:teach:badarg', 'No graphical robot of this name found');
end

%--- Find current coordinates
currentXYZ  = [get(handles.slider(1), 'Value'), get(handles.slider(2), 'Value'), get(handles.slider(3), 'Value')];
%currentXYZ = [str2double(get(handles.t6.t(1), 'String')) str2double(get(handles.t6.t(2), 'String')) str2double(get(handles.t6.t(3), 'String'))]';
info = get(h(1), 'UserData');
%Find current Joint angles
currentJoints = info.q;
%update the stored joint coordinates
set(h(1), 'UserData', info);

%set the goalXYZ to the current coordinates with the new coordinate changes
if j < 4
    switch get(src, 'Style')
        case 'slider'
            newval = get(src, 'Value');
            set(handles.edit(j), 'String', num2str(newval, 3));
        case 'edit'
            newval = str2double(get(src, 'String'));
            set(handles.slider(j), 'Value', newval);
    end
    goalXYZ = currentXYZ;
    goalXYZ(1, j) = newval;
    goalTransform = transl(goalXYZ);

    % 		qMatrix = handles.robot.getJointQMatrix(currentJoints, goalTransform, 2);

    %--- calculate the qmatrix using 2 steps
    numSteps = 2;
    goalJoints = handles.robot.model.ikcon(goalTransform, currentJoints);
    s = lspb(0, 1, numSteps);
    %get number of joints for this robot (this allows for portability
    %of the function between other robots
    nQ = size(goalJoints);
    nQ = nQ(1, 2);
    qMatrix = nan(numSteps, nQ); %-- nQ is the number of joints
    for i = 1 : numSteps
        qMatrix(i, :) = currentJoints + s(i) * (goalJoints - currentJoints);
    end

    %--- animate the robot to the new end effector position
    % 		handles.robot.animateRobot(qMatrix);
    numStepsMtx = size(qMatrix);
    numSteps = numStepsMtx(1);
    for i = 1:numSteps
        drawnow()
        %animate robot motion
        animate(handles.robot.model, qMatrix(i, :));
    end


    info.q = goalJoints;
    set(h(1), 'UserData', info);
    nQ = size(goalJoints);
    nQ = nQ(1, 2);
    for i = 1:nQ
        set(handles.slider(i+3), 'Value', goalJoints(1, i));
        set(handles.edit(i+3), 'String', num2str(goalJoints(1, i) * qscale, 3));
    end

end

if j >= 4
    switch get(src, 'Style')
        case 'slider'
            newval = get(src, 'Value');
            set(handles.edit(j), 'String', num2str(newval * qscale, 3));
        case 'edit'
            newval = str2double(get(src, 'String'));
            set(handles.slider(j), 'Value', newval / qscale);
    end
    info.q(j - 3) = newval;
    set(h(1), 'UserData', info);
    animate(handles.robot.model, info.q);

end

T6 = handles.robot.model.fkine(info.q).T;

% -- update the xyz if the joints are changed
for j = 1:3
    set(handles.slider(j), 'Value', T6(j, 4));
    set(handles.edit(j), 'String', num2str(T6(j, 4), 3));
end

% convert orientation to desired format
switch handles.orientation
    case 'approach'
        orient = T6(:,3);    % approach vector
    case 'eul'
        orient = tr2eul(T6, 'setopt', handles.opt);
    case'rpy'
        orient = tr2rpy(T6, 'setopt', handles.opt);
end

% update the top display in the teach window
for i = 1:3
    set(handles.t6.t(i), 'String', sprintf('%.3f', T6(i, 4))); %XYZ
    set(handles.t6.r(i), 'String', sprintf('%.3f', orient(i))); %RPY


end

if ~isempty(handles.callback)
    handles.callback(handles.robot, info.q);
end

end
%% Quit Callback
function quit_callback(robot, handles)
set(handles.fig, 'ResizeFcn', '');
delete(handles.panel);
set(handles.curax, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1])
end

%% Resize Callback
function resize_callback(robot, handles)

% come here on figure resize events
fig = gcbo;   % this figure (whose callback is executing)
fs = get(fig, 'Position');  % get size of figure
ps = get(handles.panel, 'Position');  % get position of the panel
% update dimensions of the axis area
set(handles.curax, 'Units', 'pixels', ...
    'OuterPosition', [ps(3) 0 fs(3)-ps(3) fs(4)]);
% keep the panel anchored to the top left corner
set(handles.panel, 'Position', [1 fs(4)-ps(4) ps(3:4)]);
end


