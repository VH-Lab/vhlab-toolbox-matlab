function str=intseq2str(A, varargin)
% INTSEQ2STR - Convert an array of integers to a compact string, maintaining sequence
%
% STR = INTSEQ2STR(A)
%
% Converts the sequence of integers in array A to a compact, human-readable 
% sequence with '-' indicating inclusion of a series of numbers and commas
% separating discontinuous numbers.
%
% The function can also take extra parameters as name/value pairs:
% Parameter (default value)    | Description
% ----------------------------------------------------------------
% sep (',')                    | The separator between the numbers
% seq ('-')                    | The character that indicates a sequential run of numbers
%
% Example:  
%     A = [1 2 3 7 10]
%     str = intseq2str(A)
%     % str == '1-3,7,10'
%
% See also: INT2STR, STR2INTSEQ
%

sep = ',';
seq = '-';

str = '';
if isempty(A),
	return;
end;

d = [Inf diff(A) Inf];
d_points = find(d~=1);

for i=1:numel(d_points)-1,
    % we are at the beginning of a run that may last 1 or more entries
	str = [str int2str(A(d_points(i)))];
	if (i+1)<=length(d_points), % is there another value left?
		gap = d_points(i+1)-d_points(i);
		if gap>1, % complete the sequence
			str = [str seq int2str(A(d_points(i+1)-1))];
			if (i+2)<=length(d_points), % need to add separator
				str = [str sep];
			end;
		elseif i~=numel(d_points)-1,  % there's another point but it's not sequential
			str = [str sep];
		end;
	end;
end;

