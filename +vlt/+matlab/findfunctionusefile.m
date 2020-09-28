function fuse = findfunctionusefile(filename, minfo)
% FINDFUNCTIONUSE determine where a function is called in an m file
%
% FUSE = FINDFUNCTIONUSE(FILENAME, MINFO)
%
% Searches the file FILENAME for uses of a Matlab function
% described by minfo returned by vlt.matlab.mfileinfo.
%
% This function searches for instances of [MINFO.NAME]
% Note that it may identify instances in the comments, or instances where the
% user has defined their own internal function of the same name.
%
% Returns a structure of possible usages
% Fieldname                     | Description
% ----------------------------------------------------------------
% fullfilename                  | Full filename of FILENAME
% name                          | Function name from MINFO.NAME
% line                          | Line number where possible usage occurred
% character                     | Character where the name occurrs
% incomments                    | 0/1 is it in a comment?
% package_class_use             | 0/1 Does a '.' appear before the function call?
% allcaps                       | 0/1 Does the function appear in all caps here? (might be documentation use)
% 
% See also: vlt.matlab.mfileinfo
%

fuse = vlt.data.emptystruct('fullfilename','name','line','character','incomments','package_class_use','allcaps');

if numel(minfo)>1,
	for j=1:numel(minfo),
		fuse = cat(1,fuse(:),vlt.matlab.findfunctionusefile(filename,minfo(j)));
	end;
	return;
end;

if ~minfo.isfunction,
	return;
end;

full = vlt.file.fullfilename(filename);
t = vlt.file.text2cellstr(filename);

for n=1:numel(t),
	comment_mark = find(t{n}=='%');  % imperfect; will find comments in a quote for instance
	if ~isempty(comment_mark),
		comment = 1:numel(t{n}) >= comment_mark(1);
	else,
		comment = zeros(size(t{n}));
	end;
	for allcaps = 0:1,
		if allcaps ==0, 
			index = strfind(t{n},minfo.name);
		else,
			index = strfind(t{n},upper(minfo.name));
		end;
		for i=1:numel(index),
			% now, we have to eliminate the case where minfo.name is part of a larger word
			part_of_word = 0;
			if index(i)>1,
				if isstrprop(t{n}(index(i)-1),'alphanum') | strcmp(t{n}(index(i)-1),'_') | strcmp(t{n}(index(i)-1),'.'),
					part_of_word = 1;
				end;
			end;
			if ~part_of_word,
				if numel(t{n})>=index(i)+numel(minfo.name), % there is a character after
					if isstrprop(t{n}(index(i)+numel(minfo.name)),'alphanum') | strcmp(t{n}(index(i)+numel(minfo.name)),'_'),
						part_of_word = 1;
					end;
				end;
			end; 
			if part_of_word, 
				continue; % skip it
			end;

			package_class_use = 0;
			if index(i)>1,
				package_class_use = strcmp(t{n}(index(i)-1),'.');
			end;
			fuse_h.fullfilename = full;
			fuse_h.name = minfo.name;
			fuse_h.line = n;
			fuse_h.character = index(i);
			fuse_h.incomments = comment(index(i));
			fuse_h.package_class_use = package_class_use;
			fuse_h.allcaps = allcaps;
			fuse(end+1,1) = fuse_h;
		end;
	end;
end;

