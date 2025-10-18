function m = cell2matn(c)
% CELL2MATN - convert a cell matrix to a numeric matrix with NaN for empty
%
% M = CELL2MATN(C)
%
% Create a numeric matrix from a cell matrix C. Empty entries of C will be
% coded as NaN entries in M. C must contain only single numeric entries.
% 
% Example:
%   a{1,1} = 1; a{1,2} = 2; a{2,1} = 3;
%   m = vlt.data.cell2matn(a);
%   % m is [ 1 2 ; 3 NaN]
%
% See also: CELL2MAT, MAT2CELL

m = NaN * ones(size(c));

for i=1:numel(c),
	v = c{i};
	if ~isempty(v),
		if ~isnumeric(v),
			error('VLT:data:cell2matn:nonNumericEntry','Non-numeric entry encountered in C.');
		end;
		if ~isscalar(v),
			error('VLT:data:cell2matn:nonScalarEntry','Non-scalar entry encountered in C.');
		end;
		m(i) = v;
	end;
end;
