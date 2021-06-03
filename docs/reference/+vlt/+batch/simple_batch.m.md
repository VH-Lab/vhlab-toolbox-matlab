# vlt.batch.simple_batch

```
  SIMPLE_BATCH - Run a simple batch
 
    vlt.batch.simple_batch(TEXTFILE)
 
    Runs a simple batch script.
 
    The TEXTFILE is assumed to be a tab-delimited text file with the first row
    describing the fields (described here):
    jobclaimfile -- the filename that will be created to "claim" the job for this Matlab
    pathtorun -- the directory that will be changed to with the cd command
    commandtorun -- the command that will be run
    savefile -- the output will be saved to this file
    errorsave -- if there is an error, the workspace will be saved to this file

```
