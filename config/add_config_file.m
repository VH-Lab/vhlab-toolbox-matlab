function add_config_file(config_filename, config_basename, varargin)
% ADD_CONFIG_FILE - Add a default configuration file to the configuration directory
%
%  ADD_CONFIG_FILE(CONFIG_FILENAME, CONFIG_BASENAME, ...)
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


config_dirpath = config_dirname;

copyfile(config_basename, [config_dirpath config_filename]);


