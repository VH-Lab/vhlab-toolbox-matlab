function r_out = rect2rect(r_in, direction)
% RECT2RECT - Convert among rectangle formats, eg [left bottom width height]->[left top right bottom]
%
%   R_OUT = RECT2RECT(R_IN, DIRECTION)
%
%   Converts rectangle R_IN to R_OUT according to format specified in DIRECTION.
%
%   DIRECTION should be a string 'IN2OUT', where IN and OUT can be any of:
%     'ltrb'   [left top right bottom]
%     'lbrt'   [left bottom right top]
%     'lbwh'   [left bottom width height]
%     'ltwh'   [left top width height]
%   
%   Case is ignored in the DIRECTION command.
%
%   See also: RESCALE_RECT

direction = lower(strtrim(direction));
two=find(direction=='2');
if isempty(two),
	error(['Unknown string input to RECT2RECT: ' direction '.']);
end;

from=direction(1:two-1);
to=direction(two+1:end);

 % convert to [ltrb]

switch from,
	case 'ltrb',
		% do nothing
	case 'lbrt',
		r_in = r_in([1 4 3 2]);
	case 'lbwh',
		r_in = [r_in(1) r_in(2)+r_in(4) r_in(1)+r_in(3) r_in(2)];
	case 'lthw',
		r_in = [r_in(1) r_in(2) r_in(1)+r_in(3) r_in(2)-r_in(4)];
	otherwise,
		error(['Unknown rect type ' from '.']);
end;

 % now we have ltrb

switch to,
	case 'ltrb',
		r_out = r_in;
	case 'lbrt',
		r_out = r_in([1 4 3 2]);
	case 'lbwh',
		r_out = [r_in(1) r_in(4) r_in(3)-r_in(1) r_in(2)-r_in(4)];
	case 'lthw',
		r_out = [r_in(1) r_in(2) r_in(3)-r_in(1) r_in(2)-r_in(4)];
	otherwise,
		error(['Unknown rect type ' to '.']);
end;

