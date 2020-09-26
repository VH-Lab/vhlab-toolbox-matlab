function add_config_file(config_filename, config_basename, varargin)
% ADD_CONFIG_FILE - Add a default configuration file to the configuration directory
%
%  vlt.config.add_config_file(CONFIG_FILENAME, CONFIG_BASENAME, ...)
%
%  Makes a copy of the file CONFIG_BASENAME and places it in a file 
%  called CONFIG_FILENAME. The CONFIG_FILENAME is located in a directory
%  called config_dirpath, which is by default determined by calling
%  CONFIG_DIRPATH.
%  
% This default behavior of this program can be modified
% by passing name/value pairs:
% NAME (default)          | Description
% -----------------------------------------------------------
% config_dirpath          | Path of where the file should be
%    (config_dirname)     |   saved


config_dirpath = vlt.config.config_dirname;

vlt.data.assign(varargin{:});

copyfile(config_basename, [config_dirpath filesep config_filename]);


