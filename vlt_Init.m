function vlt_Init 
% VLT_INIT  Add paths and initialize variables for VH Lab toolbox
% 
% Initializes the file path and global variables for package +vlt
%
% VLT_INIT()
%
% The function takes no input arguments and produces no outputs.
%
% It builds the global variables described in vlt.globals
%
% See also: vlt.globals
%

myvltpath = fileparts(which('vlt_Init'));

 % remove any paths that have the string 'vhlab-toolbox-matlab' so we don't have stale paths confusing anyone

pathsnow = path;
pathsnow_cell = split(pathsnow,pathsep);
matches = contains(pathsnow_cell, 'vhlab-toolbox-matlab');
pathstoremove = char(strjoin(pathsnow_cell(matches),pathsep));
rmpath(pathstoremove);

  % add everyelement except '.git' directories
pathstoadd = genpath(myvltpath);
pathstoadd_cell = split(pathstoadd,pathsep);
matches=(~contains(pathstoadd_cell,'.git'))&(~contains(pathstoadd_cell,'.ndi'));
pathstoadd = char(strjoin(pathstoadd_cell(matches),pathsep));
addpath(pathstoadd);

vlt.globals;

 % paths

vlt_globals.path = [];

vlt_globals.path.path = myvltpath;
vlt_globals.path.temppath = [tempdir filesep 'vlttemp'];
vlt_globals.path.testpath = [tempdir filesep 'vlttestcode'];
vlt_globals.path.filecachepath = [userpath filesep 'Documents' filesep 'vlt' filesep 'vlt-filecache'];
vlt_globals.path.logpath = [userpath filesep 'Documents' filesep 'vlt' filesep 'Logs'];
vlt_globals.path.preferences = [userpath filesep 'Preferences' filesep' 'vlt'];

if ~exist(vlt_globals.path.temppath,'dir'),
	mkdir(vlt_globals.path.temppath);
end;

if ~exist(vlt_globals.path.testpath,'dir'),
	mkdir(vlt_globals.path.testpath);
end;

if ~exist(vlt_globals.path.filecachepath,'dir'),
	mkdir(vlt_globals.path.filecachepath);
end;

if ~exist(vlt_globals.path.preferences,'dir'),
	mkdir(vlt_globals.path.preferences);
end;

vlt_globals.debug.veryverbose = 1;

 % test write access to preferences, testpath, filecache, temppath
paths = {vlt_globals.path.testpath, vlt_globals.path.temppath, vlt_globals.path.filecachepath, vlt_globals.path.preferences};
pathnames = {'vlt test path', 'vlt temporary path', 'vlt filecache path', 'vlt preferences path'};

for i=1:numel(paths),
	fname = [paths{i} filesep 'testfile.txt'];
	fid = fopen(fname,'wt');
	if fid<0,
		error(['We do not have write access to the ' pathnames{i} ' at '  paths{i} '.']);
	end;
	fclose(fid);
	delete(fname);
end;

vlt_globals.log = vlt.app.log(...
	'system_logfile',[vlt_globals.path.logpath filesep 'system.log'],...
	'error_logfile', [vlt_globals.path.logpath filesep 'error.log'],...
	'debug_logfile', [vlt_globals.path.logpath filesep 'debug.log'],...
	'system_verbosity',5,...
	'error_verbosity',5, ...
	'debug_verbosity', 5, ...
	'log_name', 'vlt',...
	'log_error_behavior','warning');

if ~isfield(vlt_globals,'cache'),
	vlt_globals.cache = vlt.data.cache();
end;

