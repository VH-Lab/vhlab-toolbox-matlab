function [v,i] = struct_name_value_search(thestruct, thename, makeerror)
% vlt.db.struct_name_value_search - search a struct with fields 'name' and 'value'
%
% [V,I] = vlt.db.struct_name_value_search(THESTRUCT, THENAME, [MAKEERROR])
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

arguments
    thestruct {mustBeA(thestruct,'struct')}
    thename (1,:) char
    makeerror (1,1) logical = true
end

if ~isfield(thestruct,'name')
    error(['THESTRUCT must have a field named ''name''.'])
end

if ~isfield(thestruct,'value')
    error(['THESTRUCT must have a field named ''value''.'])
end

tf = strcmp(thename,{thestruct.name});

i = find(tf);

if ~isempty(i)
    v = thestruct(i(1)).value;
    i = i(1);
else
    v = [];
end

if isempty(i) && makeerror
    error('vlt:db:struct_name_value_search:NotFound',...
        ['No matching entries for ' thename ' were found.']);
end