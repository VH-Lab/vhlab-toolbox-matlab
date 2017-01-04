function [h,datapoints] = median_within_between_plot(data, experiment_indexes, labels, varargin)
% MEDIAN_WITHIN_BETWEEN_PLOT - Plot an index for many experiments, different conditions
%
%  [H,DATAPOINTS]=MEDIAN_WITHIN_BETWEEN_PLOT(DATA, EXPERIMENT_INDEXES, LABELS)
%
%  Plots index values from individual experiments that are grouped into different
%  experimental conditions.  For each condition, indexes from individual animals
%  are plotted in columns. A bigger space is left between animals that are in 
%  different experimental groups.  Median values for each animal and each
%  group are highlighted with a horizontal bar.
%
%  Inputs:  There are 2 ways of specifying the data.
%    Method 1: DATA should be a cell array of index values for different conditions.
%      If there N conditions, then DATA should have N entries.  Each entry DATA{n} should
%      have the index values from a single experimental condition.  EXPERIMENT_INDEXES{n} 
%      indicates the experiment number that produced each data point in DATA{n}.
%
%    Method 2: DATA is an array of values. EXPERIMENT_INDEXES is an Mx2 matrix; the first
%      column of EXPERIMENT_INDEXES should be the experiment index number, and the second
%      column of EXPERIMENT_INDEXES should be the condition number.
%
%  LABELS{n} should be the label for the conditions.
%
%  Outputs:
%     H is a set of handles to the plots.
%     DATAPOINTS is a structure with the following fields:
%        experiment: the experiment that corresponds to the point
%        condition:  the condition of the point
%        index:      the index of the point within the condition
%        x:          the x position on the plot
%        y:          the y position on the plot (might be transformed from the raw data)

%  
%  This function's behavior can also be modified by passing additional name/value pairs:
%  Name (default):               |  Description
%  ---------------------------------------------------------------------------
%  within_width (0.25)           |  Width over which to scatter points within each
%                                |     experiment across the X axis
%  within_skip (2)               |  Amount of space on the X axis to skip between
%                                |     experiments that are within the same condition
%  between_skip (4)              |  Amount of space on the X axis to skip between conditions
%                                |
%  marker_size (5)               |  Marker size
%  marker ('o')                  |  Marker to use (see help plot)
%  plot_color ('k')              |  Plot color (see help plot)
%  smalllinewidth (1)            |  'Linewidth' parameter of median line for each experiment
%  biglinewidth (2)              |  'Linewidth' parameter of median line for each condition
%                                |
%  expernames {}                 |  An optional list of labels for each experiment
%                                |  
%  subtract1 (0)                 |  Plot 1-data instead of data?
%  dorescale (0)                 |  Should we rescale the data?
%  rescalefrom ([-1 1])          |  If dorescale==1, then rescale from this interval
%  rescaleto ([-1 1])            |        ... to this interval (see help rescale)
%
%  See also: NANMEDIAN

within_width = 0.25;
within_skip = 2;
between_skip = 4;

  % plot feature variables
marker_size = 5;
marker = 'o';
plot_color = 'k';
smalllinewidth = 1;
biglinewidth = 2;

expernames = {};

  % data modification variables
subtract1 = 0;
dorescale = 0;
rescalefrom = [-1 1];
rescaleto = [-1 1];

assign(varargin{:});

if ~iscell(data),
    [data,experiment_indexes] = conditiongroup2cell(data,experiment_indexes(:,1),experiment_indexes(:,2));
end;

datapoints.experiment = [];
datapoints.condition = [];
datapoints.index = [];
datapoints.x = [];
datapoints.y = [];

h = [];
current_x = 1;

if subtract1,
	for i=1:length(data),
		data{i} = 1-data{i};
	end;
end;

if dorescale,
	for i=1:length(data),
		data{i} = rescale(data{i},rescalefrom,rescaleto);
	end;
end;

xticks = [];

for i=1:length(data),
	group_start = current_x - within_width; 
	experiments = unique(experiment_indexes{i});
	for j=1:length(experiments),
		mydataindexes = find(experiment_indexes{i}==experiments(j));
		mydata = data{i}(mydataindexes);
		mydata_median = nanmedian(mydata);
		mydata_x = current_x + 2*(rand(size(mydata))-0.5)*within_width;

		datapoints.experiment = cat(1,datapoints.experiment(:),experiments(j)*ones(numel(mydata_x),1));
		datapoints.condition = cat(1,datapoints.condition(:),i*ones(numel(mydata_x),1));
		datapoints.index = cat(1,datapoints.index(:),mydataindexes(:));
		datapoints.x = cat(1,datapoints.x,mydata_x(:));
		datapoints.y = cat(1,datapoints.y,mydata(:));

		% now plot
		h(end+1) = plot(mydata_x,mydata,[marker plot_color],...
			'markersize',marker_size);
		hold on;
		h(end+1) = plot(current_x+within_width*[-1 1],...
				[1 1]*mydata_median,...
				[plot_color '-'],...
				'linewidth',smalllinewidth);

		if ~isempty(expernames),
			t=text(current_x+within_skip/2,mydata_median,...
				expernames{experiments(j)},'rotation',90,...
				'horizontalalignment','center','interp','none');
		end;
		group_end = current_x + within_width;
		current_x = current_x + within_skip;
	end;

	mydata_group_median = nanmedian(data{i});
	h(end+1) = plot([group_start group_end],mydata_group_median*[1 1],...
		[plot_color '-'],'linewidth',biglinewidth);
	xticks(end+1) = mean([group_start group_end]);

	current_x = current_x + between_skip;
end;

box off;
set(gca,'xtick',xticks,'xticklabel',labels);
