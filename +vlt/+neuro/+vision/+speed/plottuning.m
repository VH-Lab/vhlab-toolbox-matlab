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

colors = jet(numel(all_sfs));

for s = 1:numel(all_sfs)
    indexes = find(SF==all_sfs(s));
    % Plot the responses and calculate the speed for each spot
    speed_here = TF(indexes)./SF(indexes);
    h = plot(speed_here,R(indexes),'marker',marker,'linestyle',linestyle,'color',colors(s,:));
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
R_surf = [ R R(:,end) ; R(end,:) R(end,end)];
SF_surf = [SF SF(:,end)*2; SF(end,:) SF(end,end)*2 ];
TF_surf = [ TF TF(:,end); TF(end,:)*2 TF(end,end)*2];
surf(SF_surf,TF_surf,R_surf,R_surf);
set(gca,'View',[0 90]);
set(gca,'XScale','log','YScale','log');
set(gca,'XTick',[SF(1,:)]);
set(gca,'YTick',[TF(:,1)]);
set(gca,'FontAngle','italic');
axis([SF_surf(1,1) SF_surf(1,end) TF_surf(1,1) TF_surf(end,1)]);
shading faceted;


xlabel('Spatial frequency (c/deg)','FontAngle','italic');
ylabel('Temporal frequency (Hz)','FontAngle','italic');
