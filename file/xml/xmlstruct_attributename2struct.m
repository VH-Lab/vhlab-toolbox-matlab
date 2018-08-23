function thestruct = xmlstruct_attributename2struct(xmlstruct_input)
%  XMLSTRUCT_ATTRIBUTE2STRUCT Convert an XMLSTRUCT Name/Attribute/Data structure to Matlab structure
%  
%  THESTRUCT = XMLSTRUCT_ATTRIBUTENAME2STRUCT(XMLSTRUCT_INPUT)
%
%  Creates a Matlab structure based on a Matlab XML structure XMLSTRUCT_INPUT
%  such as that returnd by PARSEXML.
%
%  This function loops through all ATTRIBUTES of each entry of XMLSTRUCT_INPUT,
%  and creates a field in the structure THESTRUCT with the name of the attribute
%  and the 'Data' of the element. In the event that the 'Data' field is empty and
%  there is a single child in the 'Children' field, the 'Data' field of the single
%  child will be used.
%
%  See also: PARSEXML
%

thestruct = struct;

for i=1:length(xmlstruct_input),
	if isstruct(xmlstruct_input(i).Attributes),
		fn = xmlstruct_input(i).Attributes.Value;
		data = xmlstruct_input(i).Data;
		if isempty(data),
			if length(xmlstruct_input(i).Children)==1,
				data = xmlstruct_input(i).Children(1).Data;
			else,
				error([ ...  'Do not know how to set ''Data'' / ''value'' '...
					 ' field of attribute ' fn]);
			end;
		end;
		try,
			if ~any(data==':'), % ignore time data, that should remain string
				data = eval(data); % this will succeed if data is a number
			end;
		end;
		thestruct = setfield(thestruct,fn,data);
	end;
end;


