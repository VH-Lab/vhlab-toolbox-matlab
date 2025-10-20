function m = cellarray2mat(c)
% CELLARRAY2MAT - convert cell arrays of vectors to a matrix, filling with NaN
%
% M = CELLARRAY2MAT(C)
% 
% Convert a cell array of vectors to a matrix, filling in any non-present
% entries with NaN. The columns of M will be the entries of C{i}. Each entry
% C{i} must be a vector or empty.
% 
% Example:
%    c{1} = [ 1 2 3];
%    c{2} = [ 4 5 ];
%    m = vlt.data.cellarray2mat(c);
%      % m == [ 1 4; 2 5; 3 NaN]

% handle empty case explicitly
if isempty(c),
    m = [];
    return;
end;

 % determine number of columns

if ~isvector(c),
	error(['C must be [1xN] or [Nx1].']);
end;

col = numel(c);

 % determine number of rows

row = 0;
for i=1:col,
	if ~isempty(c{i}),
	 	if ~isvector(c{i}),
			error(['Found a non-vector entry in C; C{' int2str(i) '}.']);
		end;
	end;
	row = max(row,numel(c{i}));
end;

m = NaN*ones(row,col); % prefill with NaN

for i=1:col,
	for j=1:row,
		if j<=numel(c{i}),
			m(j,i) = c{i}(j);
		end;
	end;
end;


