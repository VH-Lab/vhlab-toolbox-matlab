# vlt.data.catstructfields

  CATSTRUCTFIELDS - Concatenate fields from structures with equal fields
 
   STRUCT_OUT = vlt.data.catstructfields(STRUCT1,STRUCT2[,DIMENSION])
 
   This function concatenates the contents of the field values of
   STRUCT1 and STRUCT2.  STRUCT1 and STRUCT2 must have identical fieldnames.
   DIMENSION is the dimension over which the concatenation is performed.
   If DIMENSION is not provided, then the function uses the largest
   dimension of each field as the concatenation dimension.
   
   Example:
     a.field1 = [ 1 2 3];
     a.field2 = [ 1 2 3];
     b.field1 = [ 4 5 6];
     b.field2 = [ 4 5 6];
     c = vlt.data.catstructfields(a,b);
     c.field1 % is [1 2 3 4 5 6]
     c.field2 % is [1 2 3 4 5 6]
