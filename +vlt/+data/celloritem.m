function item = celloritem(var, index, useindexforvar)
% VLT.DATA.CELLORITEM - Returns an element from a cell array or a default item
%
%   ITEM = vlt.data.celloritem(VAR, [INDEX], [USEINDEXFORVAR])
%
%   This function provides flexible access to elements within a variable VAR.
%
%   If VAR is a cell array, it returns VAR{INDEX}.
%   If VAR is not a cell array, it returns VAR itself, unless USEINDEXFORVAR is
%   set to 1, in which case it returns VAR(INDEX).
%
%   Inputs:
%   'VAR' can be any variable.
%   'INDEX' is the index of the element to retrieve (default is 1).
%   'USEINDEXFORVAR' is a boolean (0 or 1) that determines whether to index
%   into VAR if it is not a cell array (default is 0).
%
%   Example 1:
%       mycell = {'a', 'b', 'c'};
%       myvar = 'default';
%       item1 = vlt.data.celloritem(mycell, 2); % returns 'b'
%       item2 = vlt.data.celloritem(myvar, 2);  % returns 'default'
%
%   Example 2:
%       myarray = [10 20 30];
%       item3 = vlt.data.celloritem(myarray, 2, 1); % returns 20
%
%   See also: ISCELL
%

if nargin<2,
	index = 1;
end;
if nargin<3,
	useindexforvar = 0;
end

if iscell(var),
	item = var{index};
else,
	if useindexforvar,
		item = var(index);
	else,
		item = var;
	end
end;
