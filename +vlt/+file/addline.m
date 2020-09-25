function [b,errormsg] = addline(filename, message)
% ADDLINE - add a line of text to a text file
%
% [B, ERRORMSG] = ADDLINE(FILENAME, MESSAGE)
%
% ADDLINE writes a message to the textfile FILENAME. If the FILENAME does not exist, then ADDLINE
% attempts to create it. ADDLINE first attempts to check out a lock file so that two programs do not write to the
% FILENAME simultaneously. 
% 
% A newline '\n' and carriage return '\r' is added to the end of the message.
%
% If the operation is successful, B is 1 and ERRORMSG is ''. Otherwise, B is 0 and ERRORMSG describes the error.
% 

fullname = vlt.file.fullfilename(filename);

[b,errormsg] = vlt.file.createpath(fullname);

if ~b,
	return;
end;

mylockfile = [fullname '-lock'];

[lockfid,key] = vlt.file.checkout_lock_file(mylockfile);

if lockfid > 0,
	if ~exist(fullname),
		fid = fopen(fullname,'w+t');
	else,
		fid = fopen(fullname,'a+t');
	end;
	if fid<0,
		b=0;
		errormsg = ['Could not open the file ' fullname '.'];
	else,
		end_of_line = newline();
		count = fwrite(fid,[message end_of_line],'char');
		if count ~= numel(message)+numel(end_of_line),
			b = 0;
			errormsg = ['Did not write complete data.'];
		end;
		fclose(fid);
	end;
	
	vlt.file.release_lock_file(mylockfile,key);
else,
	b = 0;
	errormsg = ['Never got control of ' mylockfile '; it was busy.'];
end;


