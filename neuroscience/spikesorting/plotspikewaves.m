function [h]=plotspikewaves(waves, indexes, varargin)
% PLOTSPIKEWAVES - Plot spike waveforms to the current axes
%
%   H=PLOTSPIKEWAVES(WAVES, [INDEXES], ...)
%
% Inputs:
%  WAVES: A NumSamples x NumChannels x NumSpikes list of spike
%   waveforms. All channels are combined into 1 dimension for the plot.
%  INDEXES:  Optional, a list of index values to plot. If not provided,
%   then all waves are plotted (subject to restrictions below).
%
% Additional name/value pairs can be provided to modify the default settings
% below:
%
%  'SampleTimes'       : The sample times of each spike; default 1:(NumSamples*NumChannels) (sample numbers)
%  't'                 : The time of each spike (default 1:NumSpikes, indicating spike order only)
%  'TimeGraphBin'**    : If >0 and if t has real times, show a second graph in front of the spike
%                      :    waveforms indicating the firing rate in time bins of this size (default 0);
%                      :    otherwise show no graph
%  'TimeGraphMax'**    : The firing rate in the time graph that is considered "maximum" (default 20 (Hz))
%  'ClassID'           : 1xNumSpikes - class identity of each waveform (default 1:NumSpikes, meaning each unique)
%  'ColorOrder'        : List of colors (Nx3) to cycle through with class ID; defaults to the default
%                      :    color order for the axes, that is, get(gca,'ColorOrder').
%  'RandomSubset'      : Should we plot only a random subset? (0/1, default 1)
%  'RandomSubsetSize'  : How many waves should we plot?  (default 200)
%  'LineWidth'         : Default 0.5
%  'ClearAxes'         : Default 0
%
%   ** not implemented yet
%
%
%  Outputs:
%    H: A list of the plot handles for these waves

SampleTimes = 1:size(waves,1)*size(waves,2);
t = 1:size(waves,3);
TimeGraphBin = 0;
TimeGraphMax = 20;
ClassID = 1:size(waves,3);
ColorOrder = get(gca,'ColorOrder');
RandomSubset = 1;
RandomSubsetSize = 1000;
LineWidth = 0.5;
ClearAxes = 0;

assign(varargin{:});  % assign the user's arguments

waves = reshape(waves,size(waves,1)*size(waves,2),size(waves,3));

if nargin<2,
	index = 1:size(waves,2);
else, 
	index = indexes;
end;

if RandomSubset,
	order = randperm(length(index));
	mn = min(length(order),RandomSubsetSize);
	index = index(order(1:mn));
end;

if ClearAxes, cla; end;

h = [];

for i=1:length(index),
	if i>2, hold on; end; % explicity turn holding on if it's not; first point is up to the user
	colorindex = 1+mod(ClassID(index(i))-1, size(ColorOrder,1));
	h(end+1) = plot(SampleTimes,waves(:,index(i)),'color',ColorOrder(colorindex,:),'linewidth',LineWidth);
end;

A = axis;
axis([SampleTimes(1) SampleTimes(end) A(3) A(4)]);

box off; % at least default to good taste
