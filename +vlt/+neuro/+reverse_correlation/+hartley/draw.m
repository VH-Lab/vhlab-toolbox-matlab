function [im,out] = draw(hstruct, k, l)
% DRAW - draw a Hartley stimulus
%
% 
%

warning('not working yet')

M = hstruct.M;
angle = vlt.math.rad2deg(atan2(k,l))
if mod(hstruct.M,2)==0,
	advance = round( ((M-1-1e-6)/2)*0.5*(1-cos(4*vlt.math.deg2rad(angle))))
else,
	advance = 0;
end;

[i] = findclosest(hstruct.F_,sqrt(k^2+l^2)/M);

center = 1+1.5*M; 
selection = advance + center + (-(M-1):(M+1));

im_big = repmat(hstruct.im_offscreen(i,selection),numel(selection),1);
im_big = im_big'; 

im_big = imrotate(im_big,angle,'bilinear','crop');

if mod(hstruct.M,2)==0, % if even
	subselection = round(M/2) + (1:M);
else,
	subselection = round(M+1)/2 + (1:M); 
end;

im = im_big(subselection,subselection);

out = workspace2struct;
