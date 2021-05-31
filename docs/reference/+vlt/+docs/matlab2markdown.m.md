# vlt.docs.matlab2markdown

  MATLAB2MARKDOWN - convert Matlab documentation to markdown
 
  OUT = MATLAB2MARKDOWN(INPUT_PATH, OUTPUT_PATH, YMLPATH, OBJECTSTRUCT)
  
  Recursively converts Matlab documentation to Markdown format (.md) starting from an INPUT_PATH.
  The documentation is saved in subdirectories in OUTPUT_PATH and a yml index file is created.
 
  Optionally, one may pass an OBJECTSTRUCT with field 'object' that describes the full name of a code
  object (such as 'ndi.app') and field 'path' that describes the mkdoc yml path to that object.
 
  OUT is a structure record of the same data written to the OUTPUT_PATH.
 
  See also: vlt.docs.markdownoutput2objectstruct
