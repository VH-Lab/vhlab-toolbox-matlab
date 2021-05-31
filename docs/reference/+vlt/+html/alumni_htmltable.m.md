# vlt.html.alumni_htmltable

  FACEBOOK_HTMLTABLE - make a table of faces and names for VHlab website
 
  STR = UGALUMNI_HTMLTABLE(FACEINFO, ...)
 
  Takes as input a STRUCT FACEINFO that has fields 'imagefile' and 'name'
  and generates an html output table (in a cell array of strings) in STR.
  
  This function also takes name/value pairs that modify its behavior:
  Parameter (default value)    | Description
  ----------------------------------------------------------------
  Ncols (3)                    | Number of columns
  imagewidth (200)             | Image width, in pixels
  nametablestylestring         |    Style of the name table entries 
    ('style="text-align: center; vertical-align:top; width:200px;font-size:100%;"')  | 
  nametableprefix              | Prefix formatting for name table entries
   ('<font face="veranda, sans-serif"><b>')      | 
  nametablepostfix             | Postfix formatting for name table entries
   ('</b></font>')             |
  tableidstr ('')              | If using a style, could be ' id="facebooktable"' for example
 
  We use this to generate the undergraduate alumni portion of 
  vhlab.org/people
  
  See also: vlt.file.cellstr2text, vlt.data.namevaluepair
