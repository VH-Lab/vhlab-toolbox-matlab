function status = replacefunction(fuse, replacement_table, varargin)
% REPLACEFUNCTION - replace instances of one function call with another
%
% STATUS = REPLACEFUNCTION(FUSE, REPLACEMENT_TABLE, ...)
%
% This function examines each function use structure FUSE that is
% returned from vlt.matlab.findfunctionusefil or vlt.matlab.findfunctionusedir,
% and displays the relevant lines of code (2 above, and 2 below). It asks the
% user if they would like to replace the function (yes, no) or write a note.
% The status ("skipped", "replaced", or the note) for each entry is returned.
%
% The FUSE(i).name is looked up in the replacement_table for the replacement text.
% The replacement_table should be a struct with fields 'original', and 'replace'.
%
% This function also takes name/value pairs that modify its behavior:
% Parameter (default)            | Description
% ------------------------------------------------------------------------
% MinLine (2)                    | Minimum line number to examine; line numbers
%                                |    less than this value will not be examined
% Disable (1)                    | Disable the changes (the default)
%
% See also: vlt.matlab.findfunctionusefile, vlt.matlab.mfileinfo
%
%

MinLine = 2;
Disable = 1;

vlt.data.assign(varargin{:});

status = {};

for f=1:numel(fuse),
	tf = strcmp(fuse(f).name,{replacement_table.original});
	tfi = find(tf);
	if isempty(tfi),
		warning(['No entry for ' fuse(f).name ' in replacement table.']);
		continue;
	end;
	replacement_str = replacement_table(tfi).replacement;

	if fuse(f).line > MinLine

	else,
		status{f} = 'Skipped';
		continue; % move on to next one
	end;

	% now show the user

	t = text2cellstr(fuse(f).fullfilename);

	disp(sprintf('\n\n\n\n\n'));

	fuse(f),

	disp(sprintf('\n\n\n\n\n'));
	
	l = max(1,fuse(f).line-2) : min(fuse(f).line+2,numel(t));
	cat(1,{t{l}}'),
	disp(sprintf('\n\n'));

	t{fuse(f).line}
	reply = input(['Should we replace ' fuse(f).name ' with ' replacement_str '? ([Y]es/[N]o/[W]rite Note/[Q]uit):'],'s');

	switch lower(reply),
		case 'y',
			t{fuse(f).line}(fuse(f).character:fuse(f).character-1+numel(fuse(f).name)) = [];
			t{fuse(f).line} = [t{fuse(f).line}(1:fuse(f).character-1) replacement_str t{fuse(f).line}(fuse(f).character:end)];
			t{fuse(f).line},
			if ~Disable,
				vlt.file.cellstr2text(fuse(f).fullfilename, t);
				future = strcmp(fuse(f).fullfilename,{fuse(f+1:end).fullfilename}) & ...
					([fuse(f+1:end).line]==fuse(f).line) & ([fuse(f+1:end).character] > fuse(f).character);
				future_index = f+find(future)
				for i=1:numel(future_index),
					% adjust counts as needed
					fuse(future_index(i)),
					fuse(future_index(i)).character = fuse(future_index(i)).character + (numel(replacement_str)-numel(fuse(f).name) );
					fuse(future_index(i)),
				end;
			end;
			status{f} = 'Replaced';
			if Disable,
				status{f} = 'Replace (for fake, disabled)';
			end;
		case 'n',
			status{f} = 'Skipped';
		case 'w', 
			status{f} = input(['Write note and hit return:'],'s');
		case 'q',
			status{f} = 'Skipped due to quit';
			return;
		otherwise, 
			disp(['unknown input, skipping']);
			status{f} = 'Skipped due to unknown input';
	end; % switch
end;

