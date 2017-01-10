function dirname = config_dirname
% CONFIG_DIRNAME - Return the path location of configuration files
%
%  DIRNAME = CONFIG_DIRNAME
%
%  Defines the default location for configuration files for vhlab_mltbx_toolbox.
%  By default, the location is in a directory called 'vhlab_configuration' that 
%  is located in the same directory as vhlab_mltbx_toolbox. 
%
%  If the DIRNAME does not exist, it is created.

pathname = which('config_dirname');

pi = find(pathname==filesep);

dirname= [pathname(1:pi(end-2)) 'vhlab_configuration' filesep];

if ~exist(dirname,'dir')
	mkdir(dirname);
end;

