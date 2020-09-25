function v = version_decode(version_string)
% VERSION_DECODE - Decode a version string (a.b.c.d) into a number
%  
%  V = VERSION_DECODE(VERSION_STRING)
%
%  Decodes a version string 'a.b.c.d' into a vector of integers
%  V = [ a b c d ]
%
%  Example:
%      version_string = '5.0.32.100';
%      v = vlt.string.version_decode(version_string)
%      % v = [ 5 0 32 100]

v = [];

version_string = ['.' version_string '.'];

pers = find(version_string=='.');

for i=2:length(pers),
	v(end+1) = str2num(version_string(pers(i-1)+1:pers(i)-1));
end;

