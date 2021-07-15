function [g,max_n] = group_enumeration(m, n)
% GROUP_ENUMERATION - enumerate combinations of groups
%
% [G, MAX_N] = vlt.math.group_enumeration(M, N)
%
% Identifies members of multiple groups with a single number.
% For example, suppose we have a group of 3, a group of 2, and another
% group of 2. We want to enumerate all ways in which one member of all 3 groups can be
% combined. We assign [1 1 1] the number 1, [1 1 2] the number 2, [1 2 1] the number 3,
% and so on.
%
% M is a vector with the number of members of each group. N is the group enumeration
% number to select. G is the group selection for group enumeration N, and MAX_N is
% the maximum number of group enumerations possible. (Same as PROD(M).)
%
% Example: 
%   m = [ 1 3 1]; % 3 digit number, second digit can be 1, 2, or 3; others all 1
%   n = 2;
%   [g,max_n] = vlt.math.count_irregular_base(m,n,2);
%   % g is [1 2 1]; max_n = 3
%
%

max_n = prod(m);

if n>max_n,
	error(['n requested (' int2str(n) ') exceeds maximum value possible (' int2str(max_n) ').']);
elseif n<1,
	error(['n must be 0...' int2str(max_n) '.']);
end;

g = ones(size(m));

inc = n-1;

 % now need to redistribute any overflows

digit = numel(m); % start from last 'digit'
overflow = inc;

while (overflow>0) & digit>0,
	digit_here = mod(g(digit)+overflow,m(digit));
	if digit_here==0, 
		digit_here = m(digit);
	end;
	overflow = ceil((g(digit)+overflow)/m(digit)-1);
	g(digit) = digit_here;
	digit = digit-1;
end;

if overflow>0,
	error(['Increment exceeded maximum count.']);
end;

