%% R252 (robot) summoning



% Ikcon example code

r = EV6-900 % call in robot

exampleTR = transl(0.1,0.2,0.5); % set the location you want

q = r.model.ikcon(exampleTR); % get the joint values

steps = 50; % framerate

q0 = r.model.getpos();

qMatrix = jtraj(q0,q,steps);

for i = 1:length(qMatrix)

    r.model.animate(qMatrix(i,:)); % animate

    drawnow();

end

