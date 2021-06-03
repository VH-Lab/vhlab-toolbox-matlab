# vlt.office.vcarddata2addresslabels

```
  VCARD2LABELS - convert a VCARD file to a structure of label content
 
  V = VCARD2LABELS(VCARDDATA, ...)
 
  Identifies entries of the VCARDDATA (from vlt.file.vcard2mat) that have the
  field VFLAG. Then, an address is constructed and saved in the cell array
  of strings V. Each line of the address is a cell entry in the 2nd dimension
  of V (for example, V{i}{2} is the 2nd line of the ith address.
 
  This function also accepts name/value pairs that modify the default behavior:
  Parameter (Default)      | Description
  --------------------------------------------------------------------------
  VFLAG ('X-PHONETIC-ORG') | If this field is present, then the card should
                           |    be included in addresses.
  ADDRESSTITLELINE         | The content of the first line of the address
   ('X-PHONETIC-ORG')      |
  ADDRESS ('ADR')          | The field to use to grab the address. If this
                           |    string ends the name of the field, it will be
                           |    used.
  ADDRESS_TYPE ('HOME')    | The type of address to use
  
 
  Example:
     v = vlt.file.vcard2mat(fname);
     vout = vlt.office.vcarddata2addresslabels(v);
     vlt.office.addresslabels2pdf(vout)

```
