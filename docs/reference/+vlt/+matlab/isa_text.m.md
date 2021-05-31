# vlt.matlab.isa_text

  ISA_TEXT - examines whether a class is a subclass of another class type
 
  [B,SUBCLASSES_INCLUSIVE] = vlt.matlab.isa_text(CLASSNAME_A, CLASSNAME_B)
 
  Returns B as true if CLASSNAME_A is equal to CLASSNAME_B or if CLASSNAME_B is 
  among the superclasses of CLASSNAME_A. SUPERCLASSES_INCLUSIVE is a cell array of
  all superclasses of CLASSNAME_A including itself.
 
  Similar to ISA(A, CLASSNAME) except that both arguments are character strings instead
  of requiring one input to be an object.
 
  See also: ISA
