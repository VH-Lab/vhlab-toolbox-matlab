function out = matlab2markdown(input_path, output_path, ymlpath, objectstruct, packageprefix)
% MATLAB2MARKDOWN - convert Matlab documentation to markdown
%
% OUT = MATLAB2MARKDOWN(INPUT_PATH, OUTPUT_PATH, YMLPATH, OBJECTSTRUCT)
% 
% Recursively converts Matlab documentation to Markdown format (.md) starting from an INPUT_PATH.
% The documentation is saved in subdirectories in OUTPUT_PATH and a yml index file is created.
%
% Optionally, one may pass an OBJECTSTRUCT with field 'object' that describes the full name of a code
% object (such as 'ndi.app') and field 'path' that describes the mkdoc yml path to that object.
%
% OUT is a structure record of the same data written to the OUTPUT_PATH.
%
% See also: vlt.docs.markdownoutput2objectstruct

out = vlt.data.emptystruct('title','path');

disp(['crawling ' input_path ' ... ']);

if nargin<4,
	objectstruct = [];
end;

if nargin<5,
	packageprefix = '';
end;

if exist([input_path filesep '.matlab2markdown-ignore'],'file'),
	return;
end;

w = what(input_path);

d = dir(input_path);
d = vlt.file.dirlist_trimdots(d); % only directories that are not hidden directories

if ~exist(output_path,'dir'),
	mkdir(output_path);
end;

for i=1:numel(w.m),
	h = help([input_path filesep w.m{i}]);

	isclass = vlt.matlab.isclassfile([input_path filesep w.m{i}]);
	if isclass,
		classstr = 'CLASS ';
	else,
		classstr = '';
	end;

	doctext = ['# ' classstr vlt.matlab.mfile2package([input_path filesep w.m{i}]) newline newline];

	if ~isclass, % if it is a class, we'll write the help below
		h = ['```' sprintf('\n') h sprintf('\n') '```' sprintf('\n') ];
		doctext = cat(2,doctext,h); % write the help file
	end;

	out_here.title = vlt.matlab.mfile2package([input_path filesep w.m{i}]);
	out_here.path = [ymlpath filesep w.m{i} '.md'];

	if isclass,
		[classhelp, prop_struct, methods_struct,superclassnames] = vlt.docs.class2help([input_path filesep w.m{i}]);

		classhelp = ['```' newline classhelp newline '```' newline];
		doctext = cat(2,doctext,classhelp);

		doctext = cat(2,doctext,['## Superclasses' newline]);
		if numel(superclassnames)==0,
			doctext = cat(2,doctext, ['*none*']);
		end;
		for j=1:numel(superclassnames),
			index = [];
			if ~isempty(objectstruct),
				index = find(strcmp(superclassnames{j},{objectstruct.object}));
			end;
			linkhere = [];
			linkopen = '';
			linkclose = '';
			if ~isempty(index),
				linkhere = ['(' vlt.path.absolute2relative(objectstruct(index).path,out_here.path) ')'];
				linkopen = '[';
				linkclose = ']';
			end;
			doctext = cat(2,doctext, ['**' linkopen superclassnames{j} linkclose linkhere '**']);
			if j~=numel(superclassnames),
				doctext = cat(2,doctext,', ');
			end;
		end;

		doctext = cat(2,doctext,[newline newline '## Properties' newline newline]);

		if numel(prop_struct)==0,
			doctext = cat(2,doctext,['*none*' newline]);
		else,
			doctext = cat(2,doctext,['| Property | Description |' newline]);
			doctext = cat(2,doctext,['| --- | --- |' newline]);
			for j=1:numel(prop_struct),
				doctext = cat(2,doctext, ['| *' prop_struct(j).property '* | ' prop_struct(j).doc ' |' newline]);
			end;
		end;
		
		doctext = cat(2,doctext,[newline newline]);

		doctext = cat(2,doctext,['## Methods ' newline newline]);

		if numel(methods_struct)==0,
			doctext = cat(2,doctext,['*none*' newline]);
		else,
			doctext = cat(2,doctext,['| Method | Description |' newline '| --- | --- |' newline]);

			for j=1:numel(methods_struct),
				doctext = cat(2,doctext, ['| *' methods_struct(j).method '* | ' methods_struct(j).description ' |' newline]);
			end;
			doctext = cat(2,doctext,[newline newline]);

			doctext = cat(2,doctext,['### Methods help ' newline newline]);
			for j=1:numel(methods_struct),
				doctext = cat(2,doctext, ['**' methods_struct(j).method '** - *' methods_struct(j).description '*' newline newline ]);
				doctext = cat(2,doctext, ['```' newline methods_struct(j).help newline '```' newline newline '---' newline newline]);
			end;
		end;
	end;
		
	vlt.file.str2text([output_path filesep w.m{i} '.md'], doctext);
	out(end+1) = out_here;
end;

for i=1:numel(w.classes),
	warning(['Do not know how to write classes yet. Fix me!']);
end;

packagelist = {};

for i=1:numel(w.packages),
	packagelist{end+1} = ['+' w.packages{i}];
	out_here.title = [w.packages{i} ' PACKAGE'];
	next_inputdir = [input_path filesep '+' w.packages{i}];
	next_outputdir = [output_path filesep '+' w.packages{i}];
	next_ymlpath = [ymlpath filesep '+' w.packages{i}];
	next_packageprefix = [packageprefix w.packages{i} '.'];

	outst = vlt.docs.matlab2markdown(next_inputdir, next_outputdir, next_ymlpath, objectstruct, next_packageprefix);

	if ~isempty(outst),
		out_here.path = outst;
		out(end+1) = out_here;
	end;
end;

d = setdiff(d,packagelist);
for i=1:numel(d),
	out_here.title = [d{i} ' FOLDER'];
	next_inputdir = [input_path filesep d{i}];
	next_outputdir = [output_path filesep d{i}];
	next_ymlpath = [ymlpath filesep d{i}];

	outst = vlt.docs.matlab2markdown(next_inputdir, next_outputdir, next_ymlpath, objectstruct);

	if ~isempty(outst),
		out_here.path = outst;
		out(end+1) = out_here;
	end;
end;
