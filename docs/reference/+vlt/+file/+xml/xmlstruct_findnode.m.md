# vlt.file.xml.xmlstruct_findnode

```
  XMLSTRUCT_FINDNODE - Find a node in a Matlab struct based on XML
 
   NODE = vlt.file.xml.xmlstruct_findnode(XML_STRUCT, NODENAME)
 
   Recursively searches XML_STRUCT, an XML node tree returned from
   vlt.file.xml.parseXML, for the node with the name 'NODENAME'. It returns the node
   at that point (including all of its children).
 
   XML_STRUCT should be a structure with the following fields:
   'Name', 'Attributes', 'Data', 'Children'. The 'Children' field
   should be a structure with the same fields.
  
   See also: vlt.file.xml.parseXML

```
