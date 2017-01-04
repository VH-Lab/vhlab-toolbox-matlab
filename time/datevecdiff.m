function d = datevecdiff(v1,v2)
% DATEVECDIFF - Compute difference in date vectors, in seconds
%
%  D = DATEVECDIFF(V1,V2)
%
%  Compute the difference between 2 date vectors, V=V2-V1
%
%  V1 and V2 should be date vectors in the style of DATEVEC
%  (V1 = [year month date hour minute seconds])
%  (V2 = [year month date hour minute seconds])
%
%  Example:
%     V1=[2013 12 25 0 0 0];
%     V2=[2014 12 25 0 0 0];
%     D=datevecdiff(V1,V2)
%
%  See also: NOW, DATEVEC

d1= datenum(v1);
d2= datenum(v2);
d = (d2-d1)*24*60*60;
