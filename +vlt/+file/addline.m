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

mylockfile = [filename '-lock'];




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

