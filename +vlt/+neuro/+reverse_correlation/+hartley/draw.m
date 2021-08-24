function im = draw(hstruct, k, l)
% DRAW - draw a Hartley stimulus
%
% 
%

warning('not working yet')

M = hstruct.M;

[i] = findclosest(hstruct.F_,sqrt(k^2+l^2)/M);
advance = round(7/(8*hstruct.F_(i))),
im_big = repmat(hstruct.im_offscreen(i,advance+(1:2*M)),2*M,1);
im_big = im_big'; 


angle = vlt.math.rad2deg(atan2(k,l))

im_big = imrotate(im_big,angle,'bilinear','crop');

if mod(hstruct.M,2)==0, % if even
	coords = round(M/2) + (1:M);
else,
	coords = round(M+1)/2 + (1:M); 
end;

im = im_big(coords,coords);


