# vlt.data.sortstruct

```
  SORTSTRUCT - sort structure by fieldname values
  
  [S_sorted, indexes] = vlt.data.sortstruct(S, 'sign_fieldname1', 'sign_fieldname2', ...)
 
  Sorts the structure S according to the values in successive fieldnames.
 
  Given a structure S, S_sorted is the sorted version according to the values
  in fieldname1, fieldname2, etc. 
 
  sign should either be +1 or -1 depending upon if the data are to be sorted in
  ascending or descending order.
 
 
  Example: 
     s = struct('test1',[1],'test2',5);
     s(2) = struct('test1',[1],'test2',4); 
 
    [S_sorted,indexes] = vlt.data.sortstruct(s,'+test1','+test2');
     % indexes == [2;1] and S_sorted = s([2;1])

```
