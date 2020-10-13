function [status,result]= condarun3(env,script)
% vlt.python.condarun3 - Run a python3 script in a conda environment
% 
% [status,result] = vlt.python.condarun3(ENV, SCRIPT)
%
% Run a python3 script from the SYSTEM command in Matlab. The
% command line program "conda" will be used to run the script.
%
% Example:
%  mydir = tempdir;
%  vlt.file.str2text([tempdir filesep 'myscript.py'], 'a=1; print("Running python"); ');
%  [status,result]=vlt.python.condarun3('base',[tempdir filesep 'myscript.py'])
% 

conda_path = vlt.python.conda;
[status, result] = system([conda_path ' run -n ' env ' python3 ' script]);


