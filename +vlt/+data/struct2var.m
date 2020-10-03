function struct2var(s) 
% STRUCT2VAR - Assign variables to the fieldnames and data values of a structure
%
%  vlt.data.struct2var(S)
%
%  Assigns variables to have the name of all the fieldnames of structure S
%  with values equal to the corresponding value in structure S.
%
%  If there are already variables with the given name, they are overwritten.
%
%  Example:  
%     s.a = 5;
%     s.b = 6;
%
%     vlt.data.struct2var(s);
%     a   % now a=5
%     b   % now b=6
%
%  See also: vlt.data.var2struct


fn = fieldnames(s);

for i=1:length(fn),
	assignin('caller',fn{i}, getfield(s,fn{i}));
end;
