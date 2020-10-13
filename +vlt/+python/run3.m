function [status,result]= run3(script)
% vlt.python.run3 - Run a python3 script
% 
% [status,result] = vlt.python.run3(SCRIPT)
%
% Run a python3 script from the SYSTEM command in Matlab. The
% character string SCRIPT will be run with the executable
% that is returned from vlt.python.app3().
%
% Example:
%  mydir = tempdir;
%  vlt.file.str2text([tempdir filesep 'myscript.py'], 'a=1; print("Running python"); ');
%  [status,result]=vlt.python.run3([tempdir filesep 'myscript.py'])
% 

app_path = vlt.python.app3();

[status, result] = system([app_path ' ' script]);


