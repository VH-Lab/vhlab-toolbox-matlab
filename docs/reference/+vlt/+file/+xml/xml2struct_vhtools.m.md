# vlt.file.xml.xml2struct_vhtools

```
 XML2STRUCT - An incomplete xml string to struct conversion program
 
   STC = XML2STRUCT(XMLSTR)
 
     Converst some XML strings into Matlab structures.
 
      Accepts items in the format:
 
          <word><CONTENTS</word>
          or <word param1="value 1" param2="value 2" WS param3="value 3"/>
          or <WS word WS param1="value1" WS param2="value2" WS param3="value3" WS></word>
   
   STC is a struct with entries corresponding to the headings and parameters/values in the XML string.
 
 
   Note that this function will not process an arbitrary xml string but only files that use the three
   conventions described above.

```
