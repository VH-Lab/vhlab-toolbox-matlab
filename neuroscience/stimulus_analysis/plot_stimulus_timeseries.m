function [h,htext]=plot_stimulus_timeseries(Y, stimon, stimoff, varargin)
% PLOT_STIMULUS_TIMESERIES - plot the occurence of a stimulus or stimuli as a thick bar on a time series plot
%
% [H,HTEXT] = plot_stimulus_timeseries(Y, STIMON, STIMOFF, ...)
%
% Uses a thick horizontal bar to indicate the presentation time of a set of stimuli.
% STIMON should be a vector containing all stimulus ON times.
% STIMOFF should be a vector containing all stimulus OFF times.
% 
% This function takes additional arguments in the form of name/value pairs:
%
% Parameter (default value)          | Description
% ---------------------------------------------------------------------------
% stimid ([])                        | Stimulus ID numbers for each entry in
%                                    |     STIMON/STIMOFF; if present, will be plotted
%                                    |     Can also be a cell array of string names
% linewidth (2)                      | Line size
% linecolor ([1 1 1])                | Line color
% FontSize (12)                      | Font size for text (if 'stimid' is present)
% FontWeight ('normal')              | Font weight
% FontColor([1 1 1])                 | Text default color
% textycoord (Y+1)                   | Text y coordinate
% HorizontalAlignment ('center')     | Text horizontal alignment
% 

stimid = [];
linewidth = 2;
linecolor = [ 1 1 1];
FontSize = 12;
FontWeight = 'normal';
FontColor = [1 1 1];
textycoord = Y + 1;
HorizontalAlignment = 'center';

assign(varargin{:});

h = [];
htext = [];

for i=1:numel(stimon),
	hold on;
	h(end+1) = plot([stimon(i) stimoff(i)], [y y], 'color', linecolor, 'linewidth', linewidth);

	if ~isempty(stimid),
		xcoord = mean([stimon(i) stimoff(i)]);
		if iscell(stimid), 
			stimstr = stimid{i};
		else,
			stimstr = int2str(stimid(i));
		end
		htext(end+1) = text(xcoord, textycoord, stimstr);
		set(htext(end),'fontweight',FontWeight,'fontsize',FontSize,'HorizontalAlignment', HorizontalAlignment, 'color', 'FontColor');
	end
end


