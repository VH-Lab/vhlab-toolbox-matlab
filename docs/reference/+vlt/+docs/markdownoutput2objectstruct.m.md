# vlt.docs.markdownoutput2objectstruct

  vlt.docs.markdownoutput2objectstruct - create a list of all objects and their paths for making mkdocs links
 
  OBJECTSTRUCT = vlt.docs.markdownoutput2objectstruct(MARKDOWN_OUTPUT)
 
  Given a MARKDOWN_OUTPUT structure returned from vlt.docs.matlab2markdown, creates a structure with
  fields 'object' and 'path'. 'object' has the name of each object, and 'path' has its absolute path.
