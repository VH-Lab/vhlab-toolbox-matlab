function dirname = config_dirname
% CONFIG_DIRNAME - Return the path location of configuration files
%
%  DIRNAME = vlt.config.config_dirname
%
%  Defines the default location for configuration files for vhlab-toolbox-matlab.
%  By default, the location is in a directory called 'vhlab_configuration' that 
%  is located in the same directory as vhlab-toolbox-matlab. 
%
%  If the DIRNAME does not exist, it is created and added to the current Matlab path.

pathname = which('vlt.config.config_dirname');

pi = find(pathname==filesep);

dirname= [pathname(1:pi(end-2)) 'vhlab_configuration' filesep];

if ~exist(dirname,'dir')
	mkdir(dirname);
	addpath(dirname);
end;

