# vlt.file.xml.getXMLNodeText

  vlt.file.xml.getXMLNodeText - Read Node Text from XML
 
   VALUES = vlt.file.xml.getXMLNodeText(XDOC, LISTITEM, SUBITEM, ISNUMBER)
 
   Returns node text from the XML document XDOC.  XDOC can
   be read from a file with the Matlab command XMLREAD.
 
   LISTITEM is a string corresponding to the list item(s) requested,
     and subitem is a strong corresponding to the subitem to be
     returned.
 
   VALUES is a cell list of returned data (one cell element for each
     occurrence of LISTITEM in XDOC).  If ISNUMBER is 0, then string
     data is returned, but if ISNUMBER is 1, then the strings
     are evaluated with EVAL and the result is returned.
 
 
   Developer note: Who wrote this?? Was it Steve or Mark Mazurek?
