function [h] = spiketimes_plot(spiketimes, varargin)
% SPIKETIMES_PLOT - Plot a spike train as a bunch of hash ticks
%
%    H = vlt.neuro.spiketrains.spiketimes_plot(SPIKETIMES)
%
%    Plot a spiketrain (with spike times SPIKETIMES) on the current
%    axes as a series of hash ticks.
%
%    One can also modify the plot using the following options passed
%    as name/value pairs
%    (for example, h=vlt.neuro.spiketrains.spiketimes_plot(spiketimes,'color',[1 0 0]) plots in
%    red):
%
%    Parameter (default)  |  Description
%    ---------------------------------------------------------------------
%    color      [0 0 0]   |  Hash color ([red green blue], 0..1)
%    linewidth        1   |  Line thickness
%    hashheight      0.8  |  Height of the hash marks in axis Y units
%    hashcenter      0.5  |  Center location of the hash marks
%
%   Keywords: spiketrain spike train spiketimes times hash


color = [0 0 0];
linewidth = 1;
hashheight = 0.8;
hashcenter = 0.5;

vlt.data.assign(varargin{:});

x = repmat(spiketimes(:)',2,1);
hashy = hashcenter+hashheight*[-1 1]'/2;
y = repmat(hashy, 1, length(spiketimes));
h = plot(x,y,'-','linewidth',linewidth,'color',color);
