function h = plotmultichan(data,t,space)
% PLOT_MULTICHAN - Plots multiple channels
%
%  H = vlt.plot.plot_multichan(DATA,T,SPACE)
%
%  Plots multiple channels of DATA (assumed to be NUMSAMPLES X NUMCHANNELS)
%
%  T is the time for each sample and SPACE is the space to put between channels.
%

for i=1:size(data,2),
	if i==1, hold off; else, hold on; end;
	h(i) = plot(t,(i-1)*space+data(:,i),'color',[0.7 0.7 0.7]);
	
end;
