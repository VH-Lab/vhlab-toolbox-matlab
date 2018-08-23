function fid = checkout_lock_file(filename, checkloops, throwerror)
% CHECKOUT_LOCK_FILE Try to establish control of a lock file
%
%   FID = CHECKOUT_LOCK_FILE(FILENAME)
%
%  This function tries to check out the file FILENAME so that different
%  programs do not perform some operation at the same time. This is a quick
%  and dirty semaphore implementation (see Wikipedia if unfamilar with 
%  semaphores).  
%
%  This function tries to create an empty file called FILENAME. If the file is
%  NOT already present and the creation successful, the
%  file will be created and FID will return the file ID (see help fopen).
%
%  If instead the file already exists, the function will check
%  every 1 second for 30 iterations to see if the file disappears.
%  If the function is never able to create a new file because the 
%  old file exists, then the function will give up and return FID < 0.
%
%  IMPORTANT: RESPONSIBLE CLEANUP: It is important that if the program that
%  calls CHECKOUT_LOCK_FILE is able to create the file (that is, FID>0),
%  then it should 1) close the file with fclose(FID) and 2) delete the file
%  FILENAME that is created with delete(FILENAME). If fid<0, then
%  it should NOT delete the file FILENAME because it is checked out by
%  some other program.
%
%  The function can be called with additional output arguments:
%  
%   FID = CHECKOUT_LOCK_FILE(FILENAME, CHECKLOOPS)
%
%   Alters the number of times the function will check (at 1 second
%   intervals) to see if FILENAME has disappeared.
%
%   FID = CHECKOUT_LOCK_FILE(FILENAME, CHECKLOOPS, THROWERROR)
%
%   If THROWERROR is 1, the function will return an error instead of
%   returning FID<0.
%
%   Example:
%      % I want to make sure only my program writes to myfile.txt.
%      % All of my programs that write to myfile.txt will "check out" the 
%      % file by creating myfile.txt-lock.
%      mylockfile = 'myfile.txt-lock';
%      lockfid = checkout_lock_file(mylockfile);
%      if lockfid>0,
%         % do something
%         fclose(lockfid);
%         delete(mylockfile);
%      else,
%         error(['Never got control of ' mylockfile '; it was busy.']);
%      end;
%   
%
%  See also: FOPEN, DELETE

loops = 30;
makeanerror = 0;

if nargin>1, 
	loops = checkloops;
end;

if nargin>2,
	makeanerror = throwerror;
end;

loop = 0;

while(exist(filename,'file')==2)&loop<loops,
	pause(1);
	loop = loop + 1;
end;

if loop<loops, % we made it
	fid = fopen(filename,'w');
else,
	fid = -1;
end;

if fid<0, % we never opened it successfully, user might want us to produce an error
	if makeanerror,
		error(['Unable to obtain lock with file ' filename ...
			'.  If you believe a program that has crashed ' ...
			'created this file then you should manually delete it.']);
	end;
end;

