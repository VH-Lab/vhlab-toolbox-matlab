function status = replacefunction(fuse, replacement_str, varargin)
% REPLACEFUNCTION - replace instances of one function call with another
%
% STATUS = REPLACEFUNCTION(FUSE, REPLACEMENT_STR, ...)
%
% This function examines each function use structure FUSE that is
% returned from vlt.matlab.findfunctionusefil or vlt.matlab.findfunctionusedir,
% and displays the relevant lines of code (2 above, and 2 below). It asks the
% user if they would like to replace the function (yes, no) or write a note.
% The status ("skipped", "replaced", or the note) for each entry is returned.
%
% This function also takes name/value pairs that modify its behavior:
% Parameter (default)            | Description
% ------------------------------------------------------------------------
% MinLine(3)                     | Minimum line number to examine; line numbers
%                                |    less than this value will not be examined
%
% See also: vlt.matlab.findfunctionusefile, vlt.matlab.mfileinfo
%
%

MinLine = 3;

vlt.data.assign(varargin{:});

status = {};

for f=1:numel(fuse),
	if fuse(i).line > MinLine

	else,
		status{i} = 'Skipped';
		continue; % move on to next one
	end;

	% now show the user

	t = text2cellstr(fuse(i).fullfilename);

	disp(sprintf('\n\n\n\n\n'));
	
	l = max(1,fuse(i).line-2) : min(fuse(i).line+2,numel(t));
	t{l}
	disp(sprintf('\n\n'));

	reply = input(['Should we replace ' fuse(i).name ' with ' replacement_str '? ([Y]es/[N]o/[W]rite Note/[Q]uit):'],'s');

	switch lower(reply),
		case 'y',
			t{fuse(i).line}(fuse(i).character:fuse(i).character-1+numel(fuse(i).name)) = [];
			t{fuse(i).line} = [t{fuse(i).line(1:fuse(i).character-1) replacement_str t{fuse(i).line(i)}(fuse(i).character:end)]
			if 0,
				vlt.file.cellstr2text(fuse(i).fullfilename, t);
			end;
			future = strcmp(fuse(i).fullfilename,{fuse(i+1:end).fullfilename}) & ...
				([fuse(i+1:end).line]==fuse(i).line) & ([fuse(i+1:end).character] > fuse(i).character);
			future_index = find(future);
			for i=1:numel(future_index),
				% adjust counts as needed
				fuse(future_index(i)).character = fuse(future_index(i)).character + (numel(replacement_str)-numel(fuse(i).name) );
			end;
			status{i} = 'Replaced';
		case 'n',
			status{i} = 'Skipped';
		case 'w', 
			status{i} = input(['Write note and hit return:'],'s');
		case 'q',
			status{i} = 'Skipped due to quit';
			return;
		otherwise, 
			disp(['unknown input, skipping']);
			status{i} = 'Skipped due to unknown input';
	end; % switch
end;

