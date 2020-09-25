function ds = neuter(ds, dir_or_list)
% DIRSTRUCT/NEUTER - disable directory without removing data 
%
% DS = NEUTER(DS, DIR_OR_LIST)
%
% Given a directory or a list of directories that reside inside the path
% of the DIRSTRUCT object, NEUTER moves the file 'reference.txt' to be named
% 'reference0.txt', and re-searches the catalog of DS. This change means
% that the directory (or list of directories) will not be found among the
% test directories of DS.
%

if ~iscell(dir_or_list),
	dir_or_list = {dir_or_list}; % make it a cell for uniform processing
end

for i=1:numel(dir_or_list),
	dirpathhere = [getpathname(ds) filesep dir_or_list{i}];
	if ~exist(dirpathhere,'dir'),
		error(['No such directory ' dirpathhere '.']);
	end;
	reference_txt = [dirpathhere filesep 'reference.txt' ];
	reference0_txt = [ dirpathhere filesep 'reference0.txt' ];
	if ~exist(reference_txt,'file'),
		error(['No such file ' reference_txt '.']);
	end;
	movefile(reference_txt,reference0_txt);
end;

ds = dirstruct(getpathname(ds)); 
