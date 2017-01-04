function newvals = rescale(vals, int1, int2, noedge)

%  RESCALE - Rescale a quantity to a new interval
%
%    NEWVALS = RESCALE(VALS, INT1, INT2)
%
%  Takes values in an interval INT1 = [a b] and scales
%  them so they are now in an interval [c d].  Any values
%  less than a are set to c, and any values greater than b
%  are set to d.
%    NEWVALS = RESCALE(VALS, INT1, INT2, 'noclip')
%       will do the same as above but will not clip values
%       above b or below a.
%  
newvals = (int2(1)+((vals-int1(1))./diff(int1))*diff(int2));

if nargin<4,
    newvals(find(newvals>int2(2))) = int2(2); % in case any fall over edge
    newvals(find(newvals<int2(1))) = int2(1); % in case any fall over edge
end;