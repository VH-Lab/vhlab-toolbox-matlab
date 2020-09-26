function [i,nv] = findclosest(arr,v)
% FINDCLOSEST - Find closest value in an array (using absolute value)
%
% [I,V] = vlt.data.findclosest(ARRAY,VALUE)
%
% Finds the index to the closest member of ARRAY to VALUE
% in absolute value. It returns the index in I and the value
% in V.  If ARRAY is empty, so are I and V.
%
% If there are multiple occurrences of VALUE within ARRAY,
% only the first is returned in I.
%
% See also: FIND

if isempty(arr), i = []; nv = []; end;
[nv,i]=nanmin(abs(arr-v));
nv = arr(i);
