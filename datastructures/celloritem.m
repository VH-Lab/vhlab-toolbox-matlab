function item = celloritem(var, index)
% CELLORITEM - Returns the ith element of a cell list, or a single item
%
%   ITEM = CELLORITEM(VAR, INDEX)
%
%  This function examines VAR; if it is a cell list, then it returns
%  the INDEXth element of VAR. If it is not a cell list, then it returns
%  VAR.
%
%  This can be used to allow the user the option of providing a cell list or
%  a single entry.
%
%  Example:
%      mylist1 = {'Joe','Larry','Curly'};
%      mylist2 = 'Joe';
%
%      for i=1:3, 
%           celloritem(mylist1,i),
%           celloritem(mylist2,i),
%      end;

if iscell(var),
	item = var{index};
else,
	item = var;
end;
