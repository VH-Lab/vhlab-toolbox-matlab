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
 
   Two further consequences of comparing with ISEQUALN rather than EQLEN:
   values of different class no longer compare equal (ISEQUALN separates 'a'
   from 97, EQLEN did not), and cell-, struct- or object-valued fields are
   compared instead of throwing, since ISEQUALN does not need == to be
   defined for the class (see issue #137, item 2).

```
