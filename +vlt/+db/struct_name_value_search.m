function [v,i] = struct_name_value_search(thestruct, thename, makeerror)
% vlt.db.struct_name_value_search - search a struct with fields 'name' and 'value'
%
% [V,I] = STRUCT_NAME_VALUE_SEARCH(THESTRUCT, THENAME, [MAKEERROR])
%
% Searches a structure array THESTRUCT that is expected to have fields
% 'name' and 'value'. If there is a name matching THENAME, then the
% value of the 'value' field for that entry is returned in V.
% I is the index of the entry of THESTRUCT that had the match. If 
% there was no match, I is empty.
% If there is more than one match, V will be the value of the first match.
% 
% MAKEERROR is an optional argument (default value 1) that determines whether or
% not the function will generate an error if THENAME is not found.
%

if nargin<3,
	makerror = 1;
end;

if ~isstruct(thestruct),
	error(['THESTRUCT must be a struct array.']);
end;

if ~isfield(thestruct,'name'),
	error(['THESTRUCT must have a field named ''name''.']);
end;

if ~isfield(thestruct,'value'),
	error(['THESTRUCT must have a field named ''value''.']);
end;

tf = strcmp(thename,{thestruct.name});

i = find(tf);
v = thestruct(i(1)).value;

if isempty(i) & makeerror,
	error(['No matching entries for ' thename ' were found.']);
end;


