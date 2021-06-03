# vlt.file.xml.xmlstruct_attributename2struct

```
   XMLSTRUCT_ATTRIBUTE2STRUCT Convert an XMLSTRUCT Name/Attribute/Data structure to Matlab structure
   
   THESTRUCT = vlt.file.xml.xmlstruct_attributename2struct(XMLSTRUCT_INPUT)
 
   Creates a Matlab structure based on a Matlab XML structure XMLSTRUCT_INPUT
   such as that returnd by vlt.file.xml.parseXML.
 
   This function loops through all ATTRIBUTES of each entry of XMLSTRUCT_INPUT,
   and creates a field in the structure THESTRUCT with the name of the attribute
   and the 'Data' of the element. In the event that the 'Data' field is empty and
   there is a single child in the 'Children' field, the 'Data' field of the single
   child will be used.
 
   See also: vlt.file.xml.parseXML

```
