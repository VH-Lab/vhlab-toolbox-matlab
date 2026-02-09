function t = mkdocsnavtext(out, spaces)
% MKDOCSNAVTEXT - create navigation text for mkdoc.yml file from output of vlt.docs.matlab2markdown
%
% T = MKDOCSNAVTEXT(OUT, SPACES)
%
% Given the output structure of vlt.docs.matlab2markdown,
% creates text to put in the navigation portion of the mkdoc.yml file.
% The number of SPACES to intent must be given (often 2).
%

t = '';

for i=1:numel(out),
	t = cat(2,t,[repmat(' ',1,spaces)]);
	title_str = out(i).title;
	if ~isempty(title_str) && title_str(1)=='@',
		title_str = ['''' title_str ''''];
	end;
	t = cat(2,t,['- ' title_str]);
	if ~isstruct(out(i).path),
		t = cat(2,t,[': ''' out(i).path '''' newline]);
	else,
		t = cat(2,t,[':' newline]);
		t = cat(2,t,vlt.docs.mkdocsnavtext(out(i).path,spaces+2));	
	end;
end;

