function xml_struct = xmlstruct_stripwhitespacetext(xml_struct)
% XMLSTRUCT_STRIPTEXT - Strip nodes with name '#text' from xml structure
%
%  XML_STRUCT = XMLSTRUCT_STRIPWHITESPACETEXT(XML_STRUCT)
%
%  Recursively searches XML_STRUCT, an XML node tree returned from
%  PARSEXML, and strips out all nodes with name '#text'. These seem to 
%  correspond to whitespace.
%
%  See also: PARSEXML
%  

exclude = find(strcmp( {xml_struct.Name}, '#text' )); % find all '#text'

good = [];

for i=1:length(exclude),
	if ~isempty(strtrim(xml_struct(exclude(i)).Data)),
		good = exclude(i);
	end;
end;

exclude = setdiff(exclude,good);
include = setdiff(1:length(xml_struct),exclude);

xml_struct = xml_struct(include);

for i=1:length(xml_struct),
	if ~isempty(xml_struct(i).Children),
		xml_struct(i).Children = ...
				xmlstruct_stripwhitespace(xml_struct(i).Children);
	end;
end;

