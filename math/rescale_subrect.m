function [newrect] = rescale_subrect(subrect, original_rect, scaled_rect, format)
% RESCALE_SUBRECT - resize a rectangle within a larger rectangle according to a scale and shift
%
%  [NEWRECT] = RESCALE_SUBRECT(SUBRECT, ORIGINAL_RECT, SCALED_RECT, [FORMAT])
%
%  This function rescales a rectangle SUBRECT, whose coordinates are located with
%  respect to ORIGINAL_RECT. The same transformation that would be required to scale and
%  shift ORIGINAL_RECT to SCALED_RECT is applied to SUBRECT, and returned in NEWRECT.
%
%  FORMAT is an optional argument that specifies the format of the rectangles.
%  FORMAT == 1 (default) means [left top right bottom]
%  FORMAT == 2 means [left bottom right top]
%  FORMAT == 3 means [left bottom width height]
%  FORMAT == 4 means [left top width height]
%
%  See also: RESCALE, RECT2RECT

forms = ['ltrb' ; 'lbrt'; 'lbwh'; 'ltwh' ];

if nargin<4,
	format = 1;
end;

 % convert to ltrb
subrect = rect2rect(subrect,[forms(format,:) '2' forms(1,:)]);
original_rect = rect2rect(original_rect,[forms(format,:) '2' forms(1,:)]);
scaled_rect = rect2rect(scaled_rect,[forms(format,:) '2' forms(1,:)]);

newvalues = [ rescale(subrect([1 3]),original_rect([1 3]),scaled_rect([1 3]),'noclip') ...
		rescale(subrect([2 4]),original_rect([2 4]),scaled_rect([2 4]),'noclip') ];

newrect = newvalues([1 3 2 4]);

 % convert back

newrect = rect2rect(newrect,[forms(1,:) '2' forms(format,:)]);


