function item = celloritem(var, index, useindexforvar)
% CELLORITEM - Returns the ith element of a cell list, or a single item
%
%   ITEM = CELLORITEM(VAR, [INDEX], [USEINDEXFORVAR])
%
%  This function examines VAR:
%    if VAR is a cell list, then it returns the INDEXth element of VAR;
%    if VAR is not a cell list, then it returns VAR, unless the user specifies
%        that the INDEXth element of var should be returned (USEINDEXFORVAR=1).
%
%    If INDEX is not provided, it is assumed to be 1.
%    If USEINDEXFORVAR is not provided, it is assumed to be 0.
%
%
%  This can be used to allow the user the option of providing a cell list or
%  a single entry (Example 1) or to pull an item that may be stored as a cell list or
%  a struct (Example 2:, a JSON encoding/decoding into Matlab is underspecified and may result
%  in either a cell array or a struct array).
%
%  Example 1:
%      mylist1 = {'Joe','Larry','Curly'};
%      mylist2 = 'Joe';
%
%      for i=1:3, 
%           celloritem(mylist1,i),
%           celloritem(mylist2,i),
%      end;
%
%  Example 2: 
%     myotherlist1 = [1 2 3];
%     myotherlist2 = { [1] [2] [3]};
%
%     for i=1:3,
%           celloritem(myotherlist1,i,1),
%           celloritem(myotherlist2,i,1),
%     end

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
