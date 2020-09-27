function plotdirectionselectivity4cell_thresh(out)
% PLOTDIRECTIONSELECTIVITY4CELL - Plot the output of the 4 cell simulation
%
%    vlt.neuro.models.modelel.modeleldemo.plotdirectionselectivity4cell(OUT)
%
%  Plots the output of vlt.neuro.models.modelel.modeleldemo.directionselectivity4cell_learning1
%  to the current figure.  Note that the current figure is cleared
%  before plotting.
%
%  If SIMENDPOINT is 1, then the endpoint condition is simulated.
%
%  See also: vlt.neuro.models.modelel.modeleldemo.directionselectivity4cell_learning1

clf;

if isfield(out,'V_threshold'), 
	numplots = 4;
else,
	numplots = 4;
end;

subplot(numplots,1,1);

 % direction will be plotted in [0 1]+2.5
 di_out = [ 0 1] + 2.5;
 % output will be plotted in [0 1]+1
 sp_out = [0 1] + 1;


plot(vlt.math.rescale(out.di,[0 1],di_out),'k','linewidth',2);
hold on;
plot([1 length(out.r_up)], di_out(1)*[1 1],'k--');
plot([1 length(out.r_up)], di_out(2)*[1 1],'k--');
plot(vlt.math.rescale(out.r_up/max(out.r_up),[0 1],sp_out,'noclip'),'g','linewidth',2);
plot(vlt.math.rescale(out.r_down/max(out.r_up),[0 1],sp_out,'noclip'),'r','linewidth',2);
plot([1 length(out.r_up)], sp_out(1)*[1 1],'k--');
plot([1 length(out.r_up)], sp_out(2)*[1 1],'k--');

if numplots==1, xlabel('Trial number'); end;
ylabel('DS_{k},Up_{g},Down_{r}');
title(['Max spikes is ' num2str(max(out.r_up)) '.']);
box off;

subplot(numplots,1,2);

cmyk_color =  [ [50    50   100 0]/100; ...
		[55.69 50   0   0]/100; ...
		[50    0    100 0]/100; ...
		[55.69 0    0   0]/100; ...
		[0 1 1 0] ];

plotstyle = {'-','-',':',':'};


for j=1:size(out.gmaxes,1),
	plot(out.gmaxes(j,:),plotstyle{1+mod(j,length(plotstyle))},...
		'color',vlt.colorspace.cmyk2rgb(cmyk_color(1+mod(j,size(cmyk_color,1)),:)),...
		'linewidth',2,'DisplayName',['G' int2str(j)]);
	hold on;
end;
if numplots==2, xlabel('Trial number'); end;
ylabel('G_{max} to E');
legend;
box off;

if isfield(out,'V_threshold'),
	subplot(numplots,1,3);
	plot(out.V_threshold);
	if numplots==3, xlabel('Trial number'); end;
	ylabel('Vm threshold (V)');
	box off;
end;

if isfield(out,'r_down'),
	subplot(numplots,1,4);
	plot(out.r_up,'g','linewidth',2);
	hold on;
	plot(out.r_down,'r--','linewidth',2);
	ylabel('Spikes E');
    if numplots==4, xlabel('Trial number'); end;
end;

