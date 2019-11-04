function [indexesflared] = ROI_flare_indexes(indexes, imsize, n)
% ROI_FLARE_INDEXES - flare a given ROI specified by indexes in an image
%
%  INDEXESFLARED = ROI_FLARE_INDEXES(INDEXES, IMSIZE, N)
%
%  For an ROI specified by the INDEXES in image of size IMSIZE, return the
%  indexes of the ROI flared out by N pixels in INDEXESFLARED.
%
%  See also: IND2SUB, SUB2IND

if n>1,
    indexesflared=ROI_flare_indexes(ROI_flare_indexes(indexes,imsize,n-1),imsize,1);
    return;
end;

if length(imsize)<3, error(['Currently this function only works for 3D images.']); end;

[i, j, k] = ind2sub(imsize,indexes);

inew = i;
jnew = j;
knew = k;

for p=1:length(i),
    
    if i(p)-1 > 0,
        inew(end+1)=i(p)-1;
        jnew(end+1)=j(p);
        knew(end+1)=k(p);
    end;

 
   if i(p)+1<=imsize(1),     
        inew(end+1)=i(p)+1;
        jnew(end+1)=j(p);
        knew(end+1)=k(p);
   end;

   if j(p)-1 > 0,
        inew(end+1)=i(p);
        jnew(end+1)=j(p)-1;
        knew(end+1)=k(p);
   end;

   if j(p)+1<=imsize(2),
        inew(end+1)=i(p);
        jnew(end+1)=j(p)+1;
        knew(end+1)=k(p);
   end;

    if k(p)-1 > 0,
        inew(end+1)=i(p);
        jnew(end+1)=j(p);
        knew(end+1)=k(p)-1;
    end; 

    if k(p)+1 <=imsize(3),
        inew(end+1)=i(p);
        jnew(end+1)=j(p);
        knew(end+1)=k(p)+1;
    end;
end;
    

indexesflared = sub2ind(imsize,inew,jnew,knew);

indexesflared = unique(indexesflared);
