# vlt.string.strcmp_substitution

  STRCMP_SUBSTITUTION - Checks strings for match with ability to substitute a symbol for a string
 
   [TF, MATCH_STRING, SUBSTITUTE_STRING] = vlt.string.strcmp_substitution(S1, S2, ...)
 
   Compares S1 and S2 and returns in TF a logical 1 if they are of the same form and logical 0 otherwise.
   These strings are of the same form if
      a) S1 and S2 are identical
      b) S2 is a regular expression match of S1 (see REGEXP)
      c) S2 matches S1 when the symbol '#' in S1 is replaced by some string in S2, either as a direct comparison
         with STRCMP or a regular expression match with REGEXP. In this case, SUBSTITUTE_STRING, the string that
         can replace the SubstituteStringSymbol '#' is also returned.
   In any case, the entire matched string MATCH_STRING will be returned.
 
 
   The function also has the form:
 
   [TF, MATCH_STRING, SUBSTITUTE_STRING] = vlt.string.strcmp_substitution(S1, A, ...)
 
    where A is a cell array of strings. TF will be a vector of 0/1s the same length as A,
    and SUBSTITUTE_STRING will be a cell array of the suitable substitute strings.
    
   One can also specify the substitute string to be used (that is, not allow it to vary)
   by adding the name/value pair 'SubstituteString',THESTRING as extra arguments to the function.
 
   This file can be modified by passing name/value pairs:
 
   Parameter(default):         | Description:
   ----------------------------------------------------------------------
   SubstituteStringSymbol('#') | The symbol to indicate the substitute string 
   UseSubstituteString(1)      | Should we use the SubstituteString option?
   SubstituteString('')        | Force the function to use this string as the only acceptable
                               |    replacement for SubstituteStringSymbol
   ForceCellOutput(0)          | 0/1 should we output a cell even if we receive single strings as S1, S2?
 
 
   Examples:
             s1 = ['.*\.ext\>']; % equivalent of *.ext on the command line
             s2 = { 'myfile1.ext' 'myfile2.ext' 'myotherfile.ext1'};
             [tf, matchstring, substring] = vlt.string.strcmp_substitution(s1,s2,'UseSubstituteString',0)
 
             s1 = ['stimtimes#.txt'];
             s2 = { 'dummy.ext' 'stimtimes123.txt' 'stimtimes.txt' 'stimtimes456.txt'}
             [tf, matchstring, substring] = vlt.string.strcmp_substitution(s1,s2)
