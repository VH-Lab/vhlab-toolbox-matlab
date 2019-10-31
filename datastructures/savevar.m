function savevar(filename,vrbl,name,varargin)

% SAVEVAR - Saves variables in a Matlab file
%
%  SAVEVAR(FILENAME,VARIABLE,VARIABLENAME,OPTIONSTRING1,OPTIONSTRING2,...)
%
%  Saves the variable VARIABLE to the file FILENAME.  The name of 
%  the variable in the file will be VARIABLENAME.  OPTIONS is a 
%  string of options passed to the MATLAB SAVE command.
%
%  For example:
%
%    SAVEVAR('myfile',5,'myvariable','-append','-mat');
% 
%  See also: SAVE

eval([name '=vrbl;']);

 % a cheesy semaphore implementation so two Matlab programs don't access file at same time
fnlock = [filename '-lock'];
openedlock = 0;
loops = 0;
while (exist(fnlock,'file')==2)&loops<30,
	dowait(rand); loops=loops+1;
end;
if loops==30,error(['Could not save ' name ' to file ' filename '.']); end;

fid0 = fopen(fnlock,'w');
if fid0>0, openedlock = 1; end;

 % now save the file and clean up the temporary file if it was created
try,
	save(filename,name,varargin{:});
catch,
	if openedlock, delete(fnlock); end;
	error(['Could not save ' name ' to file ' filename '.']);
end;

if openedlock, delete(fnlock); end;

