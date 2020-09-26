function [indexes_up, indexes_down, indexes_peaks ] = theshold_crossings_epochs( input, threshold )
%THRESHOLD_CROSSINGS_EPOCHS Detect threshold crossing epochs in data and the corresponding peaks
% 
%  [INDEXES_UP,INDEXES_DOWN,INDEXES_PEAKS] = vlt.signal.threshold_crossings_epochs(INPUT, THRESHOLD)
%
%  Finds all places where the data INPUT transitions from below
%  the threshold THRESHOLD to be equal to or above the threshold
%  THRESHOLD, and returns these index values in INDEXES_UP. Note that
%  any threshold crossing that is unaccompanied by a subsequent downward
%  transition is not counted.
%  
%  Next, it finds all places where the data INPUT transitions from above
%  the threshold to below threshold, and returns these index values in
%  INDEXES_DOWN. Note that downward transitions must be associated with an
%  upward transitions, and are excluded if the first samples are above threshold.
%  (That is, the first downward transition must follow an upward transition present
%  in INPUT.)
%
%  Finally, the indexes corresponding to the locations with the largest suprathreshold
%  values between each UP and DOWN transition are returned in INDEXES_PEAK.
%
%  See also: vlt.signal.threshold_crossings

indexes_up =  vlt.signal.threshold_crossings(input,threshold);
indexes_down= 1+find( input(1:end-1)>=threshold & input(2:end) < threshold); % had to switch '=' sign

if ~isempty(indexes_down) & ~isempty(indexes_up),
	if indexes_down(1)<indexes_up(1), indexes_down = indexes_down(2:end); end;
end;
if ~isempty(indexes_down) & ~isempty(indexes_up),
	if indexes_up(end)>indexes_down(end), indexes_up = indexes_up(1:end-1); end;
end;

if isempty(indexes_down), keyboard; end;

if nargout>2, % user wants 3rd output, spend the time to compute it
	indexes_peaks = zeros(1,length(indexes_up));
	for i=1:length(indexes_up),
		[dummy,ind] = max(input(indexes_up(i):indexes_down(i)));
		indexes_peaks(i) = indexes_up(i)-1+ind;
	end;
end;


