function newrect = pixels2normalized(fig,rect)
% PIXELS2NORMALIZED - convert between pixels and normalized figure coordinates
%
% NEWRECT = pixels2normalized(FIG, RECT)
%    or
% NEWRECT = pixels2normalized(FIG_RECT, RECT)
%
% Converts a rect in 'pixels' units to 'normalized' units (see 'help axes'
% for definition).
%
% This function obtains the figure rectangle from the figure handle FIG if the
% first input argument is a figure handle, or uses the rectangle FIG_RECT
% if it is a 4-element vector.
%
% See also:  normalized2pixels

if ishandle(fig),
	b = get(fig,'position');
else,
	b = fig;
end;

newrect = ([(rect(1)-1)/b(3) (rect(2)-1)/b(4) rect(3)/b(3) rect(4)/b(4)]);
