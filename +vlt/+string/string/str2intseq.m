function a = str2intseq(str, varargin)
% STR2INTSEQ - Recover a sequence of integers from a string
%
% A = STR2INTSEQ(STR)
%
% Given a string that specifies a list of integers, with a dash ('-') indicating a run of
% sequential integers in order, and a comma (',') indicating integers that are not
% (necessarily) sequential.
%
% The function can also take extra parameters as name/value pairs:
% Parameter (default value)    | Description
% ----------------------------------------------------------------
% sep (',')                    | The separator between the numbers
% seq ('-')                    | The character that indicates a sequential run of numbers
%
% Example:
%     str = '1-3,7,10,12';
%     a = str2intseq(str);
%     % a == [1 2 3 7 10 12]

sep = ',';
seq = '-';

assign(varargin{:});

a = [];

beginnings_endings = [ 0 find(str==sep) numel(str)+1];

for i=2:numel(beginnings_endings),
	strhere = str(1+beginnings_endings(i-1):beginnings_endings(i)-1);
	strhere(find(isspace(strhere))) = []; % kill white space
	hasseq = any(strhere==seq);
	if hasseq,
		[a1]=sscanf(strhere,['%d' seq '%d']);
		a=cat(2,a,a1(1):a1(2));
	else,
		a1=sscanf(strhere,'%d');
		a=cat(2,a,a1);
	end;
end;

