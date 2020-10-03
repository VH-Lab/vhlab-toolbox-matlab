function plotdirectionselectivity4cell(out)
% PLOTDIRECTIONSELECTIVITY4CELL - Plot the output of the 4 cell simulation
%
%    PLOTDIRECTIONSELECTIVITY4CELL(OUT)
%
%  Plots the output of DIRECTIONSELECTIVITY4CELL_LEARNING1
%  to the current figure.  Note that the current figure is cleared
%  before plotting.
%
%  If SIMENDPOINT is 1, then the endpoint condition is simulated.
%
%  See also: DIRECTIONSELECTIVITY4CELL_LEARNING1

clf;

if isfield(out,'inhib_gmaxes'), 
	numplots = 6;
else,
	numplots = 6;
end;

subplot(numplots,1,1);

 % direction will be plotted in [0 1]+2.5
 di_out = [ 0 1] + 2.5;
 % output will be plotted in [0 1]+1
 sp_out = [0 1] + 1;
 % inhibitory cell, if present, will be plotted in [0 1]+0
 inhib_out = [0 1] + 0;

plot(rescale(out.di,[0 1],di_out),'k','linewidth',2);
hold on;
plot([1 length(out.r_up)], di_out(1)*[1 1],'k--');
plot([1 length(out.r_up)], di_out(2)*[1 1],'k--');
plot(rescale(out.r_up/max(out.r_up),[0 1],sp_out,'noclip'),'g','linewidth',2);
plot(rescale(out.r_down/max(out.r_up),[0 1],sp_out,'noclip'),'r','linewidth',2);
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
		'color',cmyk2rgb(cmyk_color(1+mod(j,size(cmyk_color,1)),:)),...
		'linewidth',2,'DisplayName',['G' int2str(j)]);
	hold on;
end;
if numplots==2, xlabel('Trial number'); end;
ylabel('G_{max} to E');
legend;
box off;

if isfield(out,'inhib_gmaxes'),
	subplot(numplots,1,3);

	cmyk_color =  [ ...
		[50    50   100 0]/100; ...
		[55.69 50   0   0]/100; ...
		[50    0    100 0]/100; ...
		[55.69 0    0   0]/100; ...
		[0 1 1 0] ];

	plotstyle = {'-','-',':',':'};


	for j=1:size(out.inhib_gmaxes,1),
		plot(out.inhib_gmaxes(j,:),plotstyle{1+mod(j,length(plotstyle))},...
			'color',cmyk2rgb(cmyk_color(1+mod(j,size(cmyk_color,1)),:)),...
			'linewidth',2,'DisplayName',['G' int2str(j)]);
		hold on;
	end;
	if numplots==3, xlabel('Trial number'); end;
	ylabel('G_{max} to I');
	legend;
	box off;

end; % isfield inhib_gmaxes

if isfield(out,'ctx_inhib'),
	subplot(numplots,1,4);
	plot(out.ctx_inhib);
	if numplots==4, xlabel('Trial number'); end;
	ylabel('I to E (S)');
	box off;
end;

if isfield(out,'inhib_r_up'),
	subplot(numplots,1,5);
	hold off;
	plot(out.inhib_r_up,'g','linewidth',2);
	plot(out.inhib_r_down,'r--','linewidth',2);
	ylabel('Spikes I');
end;

if isfield(out,'r_down'),
	subplot(numplots,1,6);
	plot(out.r_up,'g','linewidth',2);
	hold on;
	plot(out.r_down,'r--','linewidth',2);
	ylabel('Spikes E');
end;

