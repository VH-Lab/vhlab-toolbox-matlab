# vlt.file.xml.xmlstruct_stripwhitespace

```
  XMLSTRUCT_STRIPTEXT - Strip nodes with name '#text' from xml structure
 
   XML_STRUCT = XMLSTRUCT_STRIPWHITESPACETEXT(XML_STRUCT)
 
   Recursively searches XML_STRUCT, an XML node tree returned from
   vlt.file.xml.parseXML, and strips out all nodes with name '#text'. These seem to 
   correspond to whitespace.
 
   See also: vlt.file.xml.parseXML

```
