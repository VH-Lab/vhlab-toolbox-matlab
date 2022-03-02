function plottuning(SF,TF,R,varargin)
% vlt.neuro.vision.speed.plottuning - Plot speed tuning
%
%  vlt.neuro.vision.speed.plottuning(SF,TF,R,...)
%
%  Creates a plot like Priebe et al. 2006.
%
%  On the left side, plot the speed tuning for each spatial frequency.
%  On the right side, plot a "heat map" of response as a function of
%  spatial frequency.
%
%  This function also takes name/value pairs that modify its
%  default behavior:
%  |----------------------------------------------------------------|
%  |Parameter (default)     | Description                           |
%  |------------------------|---------------------------------------|
%  |'marker' ('o')          | Marker type to use in plot            |
%  |'linestyle' ('none')    | Line style to use                     |
%  |'do_surf' (1)           | 0/1 Should we do the surface plot?    |
%  |------------------------|---------------------------------------|
%
%  Example:
%    out = vlt.neuro.vision.speed.test.responseplay();
%    figure;
%    vlt.neuro.vision.speed.plottuning(out.SF,out.TF,out.R,'marker','d','linestyle','-');
%

marker = 'o';
linestyle = 'none';
do_surf = 1;
vlt.data.assign(varargin{:});
% On the left side
subplot(1,2,1);
hold on;

all_sfs = unique(SF); % All the spatial frequencies present

for s = 1:numel(all_sfs)
    indexes = find(SF==all_sfs(s));
    % Plot the responses and calculate the speed for each spot
    speed_here = TF(indexes)./SF(indexes);
    h = plot(speed_here,R(indexes),'marker',marker,'linestyle',linestyle);
end
set(gca,'XScale','log');
set(gca,'FontAngle','italic');

xlabel('Speed (deg/s)','FontAngle','italic');
ylabel('Response','FontAngle','italic');

% On the right side
if ~do_surf, 
    return; % stop if we aren't plotting the surface
end;

subplot(1,2,2);

% Use surf
surf(SF,TF,R,R);
set(gca,'View',[0 90]);
set(gca,'XScale','log','YScale','log');
set(gca,'XTick',[0.05 0.1 0.2 0.4 0.8 1.6]);
set(gca,'YTick',[0.5 1 2 4 8 16 32 64]);
set(gca,'FontAngle','italic');

xlabel('Spatial frequency (c/deg)','FontAngle','italic');
ylabel('Temporal frequency (Hz)','FontAngle','italic');
