function node = xmlstruct_findnode(xml_struct, nodename)
% XMLSTRUCT_FINDNODE - Find a node in a Matlab struct based on XML
%
%  NODE = XMLSTRUCT_FINDNODE(XML_STRUCT, NODENAME)
%
%  Recursively searches XML_STRUCT, an XML node tree returned from
%  PARSEXML, for the node with the name 'NODENAME'. It returns the node
%  at that point (including all of its children).
%
%  XML_STRUCT should be a structure with the following fields:
%  'Name', 'Attributes', 'Data', 'Children'. The 'Children' field
%  should be a structure with the same fields.
% 
%  See also: PARSEXML
%  

node = [];

gotit = strcmp({xml_struct.Name},nodename);

if any(gotit),
	theloc = find(gotit);
	node = xml_struct(theloc(1));
else,
	for i=1:length(xml_struct),
		node = xmlstruct_findnode(xml_struct(i).Children,nodename);
		if ~isempty(node),
			return;
		end;
	end;
end;

