function savevar(filename,vrbl,name,varargin)

% VLT.DATA.SAVEVAR - Save a variable to a .mat file with a specified name
%
%   vlt.data.savevar(FILENAME, VARIABLE, VARIABLENAME, OPTIONSTRING1, OPTIONSTRING2, ...)
%
%   Saves the given VARIABLE to a .mat file named FILENAME. The variable will
%   be saved with the name specified by VARIABLENAME.
%
%   Additional options can be passed to the built-in SAVE command as
%   trailing string arguments (e.g., '-append', '-v7.3').
%
%   This function includes a simple locking mechanism to prevent file
%   corruption when multiple Matlab instances might be saving to the same
%   file concurrently.
%
%   Example:
%       my_data = [1 2 3];
%       vlt.data.savevar('mydata.mat', my_data, 'my_variable_name');
%       % This creates 'mydata.mat' containing the variable 'my_variable_name'
%
%   See also: SAVE, LOAD, EVAL
%

eval([name '=vrbl;']);

 % a cheesy semaphore implementation so two Matlab programs don't access file at same time
fnlock = [filename '-lock'];
openedlock = 0;
loops = 0;
while (exist(fnlock,'file')==2)&loops<30,
	vlt.time.dowait(rand); loops=loops+1;
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

