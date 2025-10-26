function newrect = normalized2pixels(fig, rect)
% NORMALIZED2PIXELS - converts a 'normalized' figure rectangle to raw pixels
%
% NEWRECT = normalized2pixels(FIG,RECT)
%   or
% NEWRECT = normalized2pixels(FIG_RECT,RECT)
%
% Converts a 'normalized' rectangle (see help axes for definition) to raw
% pixels.
%
% This function obtains the figure rectangle from the figure handle FIG if the
% first input argument is a figure handle, or uses the rectangle FIG_RECT
% if it is a 4-element vector.
%
% See also:  pixels2normalized

if ishandle(fig),
	b = get(fig,'position');
else,
	b = fig;
end;
newrect=round([ rect(1)*b(3)+1 rect(2)*b(4)+1 rect(3)*b(3) rect(4)*b(4)]);
