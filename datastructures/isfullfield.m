function [b, value] = isfullfield(A, field)
% ISFULLFIELD - is there a field (or field and subfield) of a structure with a given name?
%
% [B, VALUE] = ISFULLFIELD(A, FIELD)
%
% Examines the structure A to see if A.FIELD can be evaluated. If so, B is 1 and the VALUE is
% returned in VALUE. Otherwise, B is 0. If B is 0, then VALUE is empty.
%
% See also: FIELDSEARCH 
%
% Example:
%     A = struct('a',struct('sub1',1,'sub2',2),'b',5);
%     [b,value] = isfullfield(A, 'a.sub1') % returns b==1 and value==1
%     [b2,value2] = isfullfield(A, 'a.sub3') % returns b==0 and value==[]
% 

b = 0;
value = [];

try,
	value = eval(['A.' field]);
	b = 1;
end;


