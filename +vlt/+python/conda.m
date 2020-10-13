function conda_path = conda
% vlt.python.conda - return the path to the local conda binary to use
% 
% CONDA_PATH = vlt.python.conda()
%
% Return the app path of the local conda distribution.
% The path can be edited in vhlab_configuration/matlab_python3.m.
%
% The variable to be edited in matlab_python3.m should be 
% conda_path = PATH;
%
% 


config_filename = [vlt.config.config_dirname filesep 'matlab_python3.m'];

f = exist(config_filename,'file');

if f,
	run(config_filename);
	if ~exist('conda_path','var'),
		error(['Configuration file ' config_filename ' does not define a variable named ' conda_path '.']);
	end;
else,
	if ispc(),
		error(['We do not know a default path for Windows. Edit/create ' config_filename ' with one line: conda_path=''PATH''.']);
	elseif ismac(),
		app3_path = system(['which conda']);
	elseif isunix(),
		app3_path = system(['which conda']);
	else,
		error(['Do not know how to find python here.']);
	end;
end;


