function h=plotmeanbar(data, varargin)
% PLOTMEANBAR - Plot a horizontal bar indicating mean (or standard error) of a dataset
%
% H = PLOTMEANBAR(DATA, ...)
%
% Plots the mean value of data as a horizontal bar, and, optionally, a
% vertical bar indicating the standard error.  Returns a handle(s) H to the plot.
%
% This function can be modified by name/value pairs:
% Parameter (default value)    | Description
% --------------------------------------------------------------
% xloc ([0 1])                 | The location on the x axis where the line
%                              |    should be drawn ([xstart xend])
% color ([0 0 0])              | Color of the bar (RGB)
% usestderr (1)                | 0/1 Should we plot an error bar showing
%                              |    standard error of the mean?
% useholdon (1)                | 0/1 Should we call 'hold on'?
% linewidth (2)                | Linewidth for mean bar plot
% linewidth_stderr (1)         | Linewidth for standard error plot
% measure ('nanmean(data(:))') | Function to call to obtain mean; could be 'median'
%
%  

xloc = [0 1];
color = [0 0 0];
usestderr = 1;
useholdon = 1;
linewidth = 2;
linewidth_stderr = 1;
measure = 'nanmean(data(:))';

assign(varargin{:});

if isempty(data), h = []; return; end;

d_mean = eval(measure);

if useholdon,
	hold on;
end;

h = plot(xloc,d_mean*[1 1],'color',color,'linewidth',linewidth);

if usestderr,
	d_stderr = nanstderr(data(:));

	h(end+1) = errorbar(mean(xloc),d_mean,d_stderr,d_stderr,'color',color,'linewidth',linewidth_stderr);
end;


 
