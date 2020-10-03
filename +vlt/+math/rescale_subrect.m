function [newrect] = rescale_subrect(subrect, original_rect, scaled_rect, format)
% RESCALE_SUBRECT - resize a rectangle within a larger rectangle according to a scale and shift
%
%  [NEWRECT] = vlt.math.rescale_subrect(SUBRECT, ORIGINAL_RECT, SCALED_RECT, [FORMAT])
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
%  See also: vlt.math.rescale, vlt.math.rect2rect

forms = ['ltrb' ; 'lbrt'; 'lbwh'; 'ltwh' ];

if nargin<4,
	format = 1;
end;

 % convert to ltrb
subrect = vlt.math.rect2rect(subrect,[forms(format,:) '2' forms(1,:)]);
original_rect = vlt.math.rect2rect(original_rect,[forms(format,:) '2' forms(1,:)]);
scaled_rect = vlt.math.rect2rect(scaled_rect,[forms(format,:) '2' forms(1,:)]);

newvalues = [ vlt.math.rescale(subrect([1 3]),original_rect([1 3]),scaled_rect([1 3]),'noclip') ...
		vlt.math.rescale(subrect([2 4]),original_rect([2 4]),scaled_rect([2 4]),'noclip') ];

newrect = newvalues([1 3 2 4]);

 % convert back

newrect = vlt.math.rect2rect(newrect,[forms(1,:) '2' forms(format,:)]);


