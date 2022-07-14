function objectstruct = markdownoutput2objectstruct(markdown_output)
% vlt.docs.markdownoutput2objectstruct - create a list of all objects and their paths for making mkdocs links
%
% OBJECTSTRUCT = vlt.docs.markdownoutput2objectstruct(MARKDOWN_OUTPUT)
%
% Given a MARKDOWN_OUTPUT structure returned from vlt.docs.matlab2markdown, creates a structure with
% fields 'object' and 'path'. 'object' has the name of each object, and 'path' has its absolute path.
% 

objectstruct = vlt.data.emptystruct('object','path','url_prefix');

for i=1:numel(markdown_output),
	if ~isstruct(markdown_output(i).path),
		newentry.object = markdown_output(i).title;
		newentry.path = markdown_output(i).path;
        newentry.url_prefix = markdown_output(i).url_prefix;
		objectstruct(end+1) = newentry;
	else, 
		objectstruct = cat(2,objectstruct, vlt.docs.markdownoutput2objectstruct(markdown_output(i).path));
	end;
end;

