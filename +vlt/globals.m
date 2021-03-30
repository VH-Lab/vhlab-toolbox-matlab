% vlt.globals - define global variables for VLT (VH Lab tools)
%
% vlt.globals
%  
% Script that defines some global variables for the VLT package
%
% The following variables are defined:
% 
% Name:                            | Description
% -------------------------------------------------------------------------
% vlt_globals.path.path            | The path of the VLT distribution on this machine
%                                  |   (Initialized by vlt_Init.m)
% vlt_globals.path.preferences     | A path to a directory of preferences files
% vlt_globals.path.filecachepath   | A path where files may be cached (not deleted every time)
% vlt_globals.path.temppath        | The path to a directory that may be used for
%                                  |   temporary files (Initialized by ndi_Init.m)
% vlt_globals.path.testpath        | A path to a safe place to run test code
% vlt_globals.debug                | A structure with preferences for debugging
% vlt_globals.log                  | An object that manages writing system, error, debugging logs (vlt.app.log)
% vlt_globals.cache                | A vlt.data.cache object for the use of the toolbox
%

global vlt_globals

