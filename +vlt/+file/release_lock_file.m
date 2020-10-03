function [b] = release_lock_file(fid_or_filename, key)
% RELEASE_LOCK_FILE - release a lock file with the key
%
% B = vlt.file.release_lock_file(FID_OR_FILENAME, KEY)
%
% Release a lock file given its FID or its FILENAME and the
% correct KEY that was issued by the function vlt.file.checkout_lock_file.
% Removes the file if the key matches.
%
% B is 1 if the lockfile is either not present or if it was removed
% successfully.
% 
% B is 0 if the key does not match (and the file is not removed.)
%
% An error is triggered if the lock file does not have the expected contents
% (an expiration time and a key).
%
% See also: vlt.file.checkout_lock_file
% 
% For an example, see vlt.file.checkout_lock_file
% 

if isnumeric(fid_or_filename),
	% we have a fid
	fid = fid_or_filename;
	filename = fopen(fid);
	fclose(fid);
elseif ischar(fid_or_filename),
	filename = fid_or_filename;
	fid = -1;
end;

if ~exist(filename, 'file'),
	% the file is gone, so it is already released
	b = 1;
	return;
end;

C = vlt.file.text2cellstr(filename);

if numel(C)~=2,
	error([filename ' does not appear to be a lock file created by vlt.file.checkout_lock_file.']);
end;

if strcmp(strtrim(C{2}),key), 
	% we have the correct key
	b = 1;
	delete(filename);
else,
	b = 0;
end;


