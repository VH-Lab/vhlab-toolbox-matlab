function app3_path = app3
% vlt.python.app3 - return the path to the local python3 distribution to use
% 
% APP3_PATH = vlt.python.app3()
%
% Return the app path of the local python3 distribution.
% The path can be edited in vhlab_configuration/matlab_python3.m.
%
% 


config_filename = [vlt.config.config_dirname filesep 'matlab_python3.m'];

f = exist(config_filename,'file');

if f,
	run(config_filename);
	if ~exist('app3_path','var'),
		error(['Configuration file ' config_filename ' does not define a variable named ' app3_path '.']);
	end;
else,
	if ispc(),
		error(['We do not know a default path for Windows. Edit/create ' config_filename ' with one line: app3_path=''PATH''.']);
	elseif ismac(),
		app3_path = system(['which python3']);
	elseif isunix(),
		app3_path = system(['which python3']);
	else,
		error(['Do not know how to find python here.']);
	end;
end;


