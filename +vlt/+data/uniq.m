function y = uniq(x)
% uniq - find the unique elements in a vector
%
% y = vlt.data.uniq (x) returns a vector shorter than x with all sequential
% occurances but the first of the same element eliminated.
%
% cf. the unix uniq command.  Also see SORT.

y(1) = x(1);
j = 2;

for i = 2:max(size(x))
  if x(i) ~= x(i-1)
    y(j) = x(i);
    j = j+1;
  end
end


