function b = isempty_cell(thecell)
%  ISEMPTY_CELL - Returns elements of a cell variable that are empty/not empty
%
%  B = ISEMPTY(THECELL)
%
%  Returns a logical array the same size as THECELL. Each entry of the array B
%  is 1 if the contents of the cell is empty, and 0 otherwise.
%
%  Example:
%
%     A = {'test', [] ; [] 'more text'}
%     B = isempty_cell(A)
%
%     B =
%           0     1
%           1     0
%  

b = zeros(size(thecell));

for i=1:length(b(:)),
	b(i) = isempty(thecell{i});
end;
