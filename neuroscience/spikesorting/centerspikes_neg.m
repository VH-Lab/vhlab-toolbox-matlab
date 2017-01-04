function [centeredspikes] = centerspikes_neg(spikeshapes, center_range)
% CENTERSPIKES_NEG Center negative-going spike waveforms based on minimum
%  [CENTEREDSPIKES] = CENTERSPIKES_NEG(SPIKESHAPES, CENTER_RANGE)
%
%  Inputs: SPIKESHAPES: an NxMxD vector where N is the number of spikes, M is the number of
%           samples that comprise each spike waveform, and D is dimensions (i.e., number of
%           channels).
%          CENTER_RANGE: the range, in samples, around the center sample that the program
%           should search to identify the center (e.g., 10)
%  Outputs: 
%          CENTEREDSPIKES: the re-centered spikes; if the center of a spike has shifted, then
%           the edges will be zero padded.


fits = [];
centeredspikes = [];

[N,M,D] = size(spikeshapes);

center_pts = round((M-1)/2) + [-center_range:center_range ];

for i=1:N,
	% fit the size for the dimension that has the largest negative going spike
	ss = squeeze(spikeshapes(i,center_pts,:));
	if size(spikeshapes,3)==1,
		ss = ss';
	end;
	[v,m] = min(ss);
	[v2,dm] = min(v); % dimension that has minimum point
	min_index = m(dm);
	shift = center_pts(min_index) - round((M-1)/2);
	paddedspike = cat(2,zeros(1,center_range,D),spikeshapes(i,:,:),zeros(1,center_range,D));
	paddedspike = paddedspike(1,shift+center_range+1:end+shift-center_range,:);
	centeredspikes = cat(1,centeredspikes,paddedspike);
end;

