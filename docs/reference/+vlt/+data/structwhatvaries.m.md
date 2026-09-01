# vlt.data.structwhatvaries

```
  STRUCTWHATVARIES - Identify what varies among a cell list of structure objects
 
   DESCR = vlt.data.structwhatvaries(CELLLISTOFSTRUCTURES)
 
   Given a cell list of structures, returns a list of the fieldnames that vary in
   value across the cell list.
 
   Values are compared with ISEQUALN, so NaN is equal to NaN: a field that is
   NaN in *every* structure is NOT reported as varying. Until issue #137
   (item 3) this used EQLEN, which bottoms out in X==Y, so an all-NaN field
   came back as varying over a single distinct value. EQLEN itself is
   unchanged -- the fix is at this call site only, as NDI-matlab#902 did.
 
   NaN is the only change in answer for ordinary values. ISEQUALN compares a
   char against its double code point exactly as == does, so 'a' and 97 still
   count as equal; an earlier draft of this note claimed otherwise and CI
   refuted it. ISEQUALN does not need == to be defined at all, so struct- and
   object-valued fields compare here rather than raising.

```
