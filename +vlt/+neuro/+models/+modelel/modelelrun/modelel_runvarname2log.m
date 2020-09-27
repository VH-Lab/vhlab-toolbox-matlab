function [element, string] = modelel_runvarname2log(varname)
% MODELEL_RUNVARNAME2LOG - Convert a variable name output for the C version
%
%   [ELEMENT, STRING] = vlt.neuroscience.models.modelel.modelelrun.modelel_runvarname2log(VARNAME)
%
%  Looks at the VARNAME string and identifies the element number that is
%  operated upon (returned as an integer in ELEMENT) and the string of the
%  variable name.
%
%

element = sscanf(varname,'modelrunstruct.Model_Final_Structure(%d)');

periods = find(varname=='.');

if length(periods)==2, 
	string = varname(periods(2)+1:end);
else,
	string = varname(periods(3)+1:end);
end;
