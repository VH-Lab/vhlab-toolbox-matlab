function [classhelp, prop_struct, methods_struct,superclassnames] = class2help(filename)
% CLASS2HELP - get help information from a Matlab class .m file
%
% [CLASSHELP, PROP_STRUCT, METHODS_STRUCT, SUPERCLASSES] = CLASS2HELP(FILENAME)
%
% Returns the help string CLASSHELP, a list of properties and the
% 'doc' information for each property in PROP_STRUCT, and the name of each
% method and the help in a structure called METHODS_STRUCT.
%
% PROP_STRUCT has fields 'property' and 'doc' that contain each property and
% its 'doc' string.
% 
% METHODS_STRUCT has fields 'method', 'description' (the first line from the
% documentation), and 'help' (lines 2..n of the function 'help').
%
% SUPERCLASSES is a list of all superclasses for the file.

isclass = vlt.matlab.isclassfile(filename);

if ~isclass,
	error([filename ' does not appear to be a class file.']);
end;

packagename = vlt.matlab.mfile2package(filename);

classhelp_ = help(filename);
[classhelp,pos,linemarks] = [vlt.string.line_n(classhelp_,1)];
classhelp(end+1) = sprintf('\n');
for i=2:numel(linemarks)-3, % remove last 3 lines that indicate documentation
	classhelp = cat(2,classhelp,line_n(classhelp_,i),sprintf('\n'));
end;

t = vlt.file.text2cellstr(filename);

prop_struct = vlt.data.emptystruct('property','doc');
p = properties(packagename);

for i=1:numel(p),
	phere.property = p{i};
	phere.doc = '';

	for j=1:numel(t),
		[start,stop] = regexp(t{j},[p{i} '(\s)*[%](\s)*'],'forceCellOutput');
		if ~isempty(start{1}),
			phere.doc = strtrim(t{j}(stop{1}(end)+1:end));
			break;
		end;
	end;

	prop_struct(end+1) = phere;
end;

methods_struct = vlt.data.emptystruct('method','description','help');

m = methods(packagename);

for i=1:numel(m),
	h = help([packagename filesep m{i}]);
	newline_locs = find(h==newline);
	mhere.method = m{i};
	mhere.description = '';
	if ~isempty(newline_locs),
		mhere.description = strtrim(h(1:newline_locs(1)-1));
		mhere.help = strtrim(h(newline_locs(1)+1:end));

		dash = find(mhere.description=='-');
		if ~isempty(dash),
			if dash(1)+1 < numel(mhere.description),
				mhere.description = strtrim(mhere.description(dash(1)+1:end));
			end;
		end;
	else,
		mhere.help = h;
	end;
	methods_struct(end+1) = mhere;
end;

superclassnames = superclasses(packagename);


