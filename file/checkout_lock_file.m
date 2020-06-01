function [fid,key] = checkout_lock_file(filename, checkloops, throwerror, expiration)
% CHECKOUT_LOCK_FILE Try to establish control of a lock file
%
%  [FID,KEY] = CHECKOUT_LOCK_FILE(FILENAME)
%
%  This function tries to check out the file FILENAME so that different
%  programs do not perform some operation at the same time. This is a quick
%  and dirty semaphore implementation (see Wikipedia if unfamilar with 
%  semaphores). The LOCKFILE will also EXPIRE in 1 hour unless otherwise specified
%  below. A KEY is returned, which is necessary to pass to to RELEASE_LOCK_FILE.
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
%  
%
%  IMPORTANT: RESPONSIBLE CLEANUP: It is important that if the program that
%  calls CHECKOUT_LOCK_FILE is able to create the file (that is, FID>0),
%  then it should call RELEASE_LOCK_FILE to remove the lock file.
%  
%  IMPORANT: FILE CLOSURE: If 2 output arguments are given (that is, KEY is
%  examined), then the lock file is closed before CHECKOUT_LOCK_FILE exits.
%  If KEY is not requested in output, then the FID is left open for 
%  backwards compatibility.
%
%  Depricated release instructions (new code should not use): 
%  1) close the file with fclose(FID) and 2) delete the file
%  FILENAME that is created with delete(FILENAME).  If FID<0, then
%  it should NOT delete the file FILENAME because it is checked out by
%  some other program.
%
%  The function can be called with additional output arguments:
%  
%  [FID,KEY] = CHECKOUT_LOCK_FILE(FILENAME, CHECKLOOPS)
%
%  Alters the number of times the function will check (at 1 second
%  intervals) to see if FILENAME has disappeared.
%
%  [FID,KEY] = CHECKOUT_LOCK_FILE(FILENAME, CHECKLOOPS, THROWERROR)
%
%  If THROWERROR is 1, the function will return an error instead of
%  returning FID<0.
%
%  [FID,KEY] = CHECKOUT_LOCK_FILE(FILENAME, CHECKLOOPS, THROWERROR, EXPIRATION_SECONDS)
%
%  This mode allows one to specifically set the expiration time in seconds.
%  CHECKOUT_LOCK_FILE will examine the file for the expiration time and 
%  ignore and remove the lock file if it is "expired". By default, EXPIRATION_SECONDS
%  is 3600.
%
%  Example:
%     % I want to make sure only my program writes to myfile.txt.
%     % All of my programs that write to myfile.txt will "check out" the 
%     % file by creating myfile.txt-lock.
%     mylockfile = [userpath filesep 'myfile.txt-lock'];
%     [lockfid,key] = checkout_lock_file(mylockfile);
%     if lockfid>0,
%        % do something
%        release_lock_file(mylockfile,key);
%     else,
%        error(['Never got control of ' mylockfile '; it was busy.']);
%     end;
%   
%
%  See also: RELEASE_LOCK_FILE, FOPEN, DELETE

loops = 30;
makeanerror = 0;
expiration_time = 3600;
key = [num2hex(now) '_' num2hex(rand)];

 % process inputs

if nargin>1, 
	if ~isempty(checkloops),
		loops = checkloops;
	end;
end;

if nargin>2,
	if ~isempty(throwerror),
		makeanerror = throwerror;
	end;
end;

if nargin>3,
	if ~isempty(expiration),
		expiration_time = expiration;
	end;
end;

 % now check

loop = 0;

expiration_time_of_file = Inf;
isexpired = 0;

while ( exist(filename,'file') & loop<loops ),
	file_exists = exist(filename,'file');

	if file_exists,
		C = text2cellstr(filename);
		if ~isempty(C),
			try,
				expiration_time_of_file = datetime(strtrim(C{1}),'TimeZone','UTCLeapSeconds');
			end;
		end;
	end;
	
	if ~isinf(expiration_time_of_file),
		isexpired = expiration_time_of_file < datetime('now','TimeZone','UTCLeapSeconds');
	end;

	if ~isexpired,
		% some fun debugging statements
		%if ~isinf(expiration_time_of_file),
		%	disp('not expired.');
		%else,
		%	disp('will not expire.');
		%end;
		pause(1);
	else,	% it is expired; we get to delete it
		delete(filename);
	end;
	loop = loop + 1;
end;

if loop<loops, % we made it
	fid = fopen(filename,'wt','ieee-le');
	t1 = datetime('now','TimeZone','UTCLeapSeconds');
	t2 = t1 + seconds(expiration_time);
	exp_str = char(datetime(t2,'TimeZone','UTCLeapSeconds'));
	fprintf(fid,'%s\n%s\n',exp_str,key);
else,
	fid = -1;
end;

if fid<0, % we never opened it successfully, user might want us to produce an error
	if makeanerror,
		error(['Unable to obtain lock with file ' filename ...
			'.  If you believe a program that has crashed ' ...
			'created this file then you should manually delete it.']);
	end;
else,
	if nargin>1, % if we are getting the key, we should close the lock file
		fclose(fid);
	end;
end;


