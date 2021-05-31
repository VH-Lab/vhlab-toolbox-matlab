# vlt.file.addline

  ADDLINE - add a line of text to a text file
 
  [B, ERRORMSG] = ADDLINE(FILENAME, MESSAGE)
 
  ADDLINE writes a message to the textfile FILENAME. If the FILENAME does not exist, then ADDLINE
  attempts to create it. ADDLINE first attempts to check out a lock file so that two programs do not write to the
  FILENAME simultaneously. 
  
  A newline '\n' and carriage return '\r' is added to the end of the message.
 
  If the operation is successful, B is 1 and ERRORMSG is ''. Otherwise, B is 0 and ERRORMSG describes the error.
