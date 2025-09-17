function [i,nv] = findclosest(arr,v)
% FINDCLOSEST - Find closest value in an array (using absolute value)
%
% [I,V] = vlt.data.findclosest(ARRAY,VALUE)
%
%   Finds the index to the closest member of ARRAY to VALUE.
%   The comparison is based on absolute difference.
%
%   Outputs:
%   'I' is the index of the closest member.
%   'V' is the value of the closest member.
%
%   If ARRAY is empty, I and V will also be empty.
%   If there are multiple occurrences of the closest value, the index of the
%   first one is returned.
%
%   Example:
%       array = [1 5 10 15];
%       value = 6;
%       [i, v] = vlt.data.findclosest(array, value);
%       % i will be 2, v will be 5
%
%   See also: FIND, MIN, ABS
%

if isempty(arr), i = []; nv = []; end;
[nv,i]=nanmin(abs(arr-v));
nv = arr(i);
