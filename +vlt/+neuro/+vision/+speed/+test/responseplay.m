function out = responseplay()
% vlt.neuro.vision.speed.responseplay - A function to demonstrate the speed tuning response function
%
%  OUT = vlt.neuro.vision.speed.test.responseplay()
%
[SF,TF] = meshgrid([0.05 0.08 0.1 0.2 0.4 0.8 1.2],[0.5 1 2 4 8 16 32]);

% Pick some parameters
A = 1;
zeta = 0;
xi = 0;
sigma_sf = 0.2; % Cycles per degree
sigma_tf = 4; % Cycles per second; this is the fall off
sf0 = 0.1; % Preferred spatial frequency
tf0 = 4; % Preferred temporal frequency

% Now calculate the responses
R = vlt.neuro.vision.speed.tuningfunc(SF,TF,[A zeta xi sigma_sf sigma_tf sf0 tf0]);

SF, TF, R % Print the values

% Now plot the responses
figure;
plot(TF(:,3),R(:,3),'o');
set(gca,'FontAngle','italic');

xlabel('Temporal frequency (Hz)','FontAngle','italic');
ylabel('Response','FontAngle','italic');

out = vlt.data.workspace2struct();
