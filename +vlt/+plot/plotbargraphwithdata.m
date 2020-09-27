function h=plotbargraphwithdata(data, varargin)
% PLOTMEANBAR - Plot a bar graph indicating mean, standard error, and raw data
%
% H = vlt.plot.plotbargraphwithdata(DATA, ...)
%
% Plots a bar graph with height equals to the mean value of the the mean value
% of each dataset in the cell array DATA{i}. The standard error of the mean is
% shown with error bars offset by XOFFSET. The raw data is plotted offset by
% XOFFSET.
%
% This function can be modified by name/value pairs:
% Parameter (default value)    | Description
% --------------------------------------------------------------
% xloc (linspace(1,...         | The location on the x axis where the bars
%    numel(data),,numel(data)))|    should be drawn ([xstart xend])
% barcolor ([0.4 0.4 0.4])     | Color of the bar graph (RGB)
% datacolor ([0 0 0])          | Color of the raw data (RGB)
% stderrcolor ([0 0 0])        | Color of the std error bars (RGB)
% usestderr (1)                | 0/1 Should we plot an error bar showing
%                              |    standard error of the mean?
% userawdata (1)               | 0/1 Should we plot the raw data?
% useholdon (1)                | 0/1 Should we call 'hold on'?
% linewidth (2)                | Linewidth for mean bar plot
% linewidth_stderr (1)         | Linewidth for standard error plot
% symbolsize (6)               | Symbol size
% symbol ('o')                 | Symbol to use
% xoffset (0.25)               | X offset for plotting standard error, raw data
% measure ('nanmean(data(:))') | Function to call to obtain mean; could be 'median', e.g.
%
%  

xloc = linspace(1,numel(data),numel(data));
barcolor = 0.4+[0 0 0];
datacolor = [0 0 0];
stderrcolor = [0 0 0];
usestderr = 1;
useholdon = 1;
linewidth = 2;
linewidth_stderr = 1;
userawdata = 1;
symbolsize = 6;
symbol = 'o';
xoffset = 0.2;
measure = 'nanmean(data{i}(:))';

vlt.data.assign(varargin{:});

if isempty(data), h = []; return; end;

holdisonnow = ishold();

if useholdon,
	hold on;
end;

mns = [];
stderrs = [];

for i=1:numel(data),
	mns(i) = eval(measure);
	stderrs(i) = vlt.data.nanstderr(data{i}(:));
end;

hb = bar(xloc,mns);
set(hb,'facecolor',barcolor);
hold on;

if usestderr,
	he = vlt.plot.myerrorbar(xloc-xoffset,mns,stderrs,stderrs);
	set(he, 'color',stderrcolor,'linewidth',linewidth_stderr);
	delete(he(2));
	he = he(1);
end;

hd = [];
if userawdata,
	for i=1:numel(data),
		hd = cat(1,hd,plot(xloc(i)+xoffset,data{i}(:),...
			'Marker', symbol, ...
			'color',color, 'markersize',symbolsize));
	end;
end;
 
 % return hold state to what it was

if holdisonnow,
	hold on;
else,
	hold off;
end;

h = cat(1,hb,he,hd(:));

