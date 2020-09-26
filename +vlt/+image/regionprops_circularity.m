function newstats = regionprops_circularity(stats)
% REGIONPROPS_CIRCULARITY - Calculates circularity of regions of interests
%
%   NEWSTATS = REGIONPROPS_CIRCULARITY(STATS)
%
%   Calculates circularity for regions of interest that have been
%   returned by the IMAGES toolbox routines BWLABEL, BWBOUNDARIES, etc.
%
%   STATS must be a structure of stats returned by the function
%   REGIONPROPS that includes that parameters 'Area' and 
%   'Perimeter' (see 'help regionprops').
%
%   NEWSTATS is a structure that has all of the fields of STATS plus the
%   additional field 'Circularity'.
%
%   Circularity is defined as 4*pi(area/perimeter^2)
%
%   Inspired from a plugin for ImageJ contributed by Wayne Rasband
%

if ~isfield(stats,'Area') | ~isfield(stats,'Perimeter'),
	error(['STATS must include fields ''Area'' and ''Perimeter''']);
end;

circularity = 4*pi*([stats(:).Area]./([stats(:).Perimeter].^2));

for i=1:length(stats),
	dummy = stats(i);
	dummy.Circularity = circularity(i);
	newstats(i) = dummy;
end;

