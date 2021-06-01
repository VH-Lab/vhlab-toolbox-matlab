# vlt.file.combinepdf

  COMBINEPDF - Merge PDF (portable document format) files on Mac OS X
 
   vlt.file.combinepdf(MERGEFILENAME, FILE1, FILE2, ...)
 
   On Mac OS X, this function calls the command line tool
   /System/Library/Automator/Combine PDF Pages.action/Contents/Resources/join.py
   to merge PDF files.
   
   INPUTS: MERGEFILENAME is the name of the merged file. If it exists,
   it will be deleted. The filenames to be merged (FILE1, FILE2, ...) are
   passed as additional arguments. The filenames should either be in full
   path format or should be in the local directory.
   
   This function will fail on platforms other than Mac OS X.
