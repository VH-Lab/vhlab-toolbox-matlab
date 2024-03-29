function [im,out] = draw(hstruct, s, k, l)
% DRAW - draw a Hartley stimulus
%
% [IM,OUT] = vlt.neuro.reverse_correlation.hartley.draw(HSTRUCT, K, L)
%
% Draw a Hartley stimulus from a structure returned
% from vlt.neuro.reverse_correlation.hartley.build (HSTRUCT)
% for Hartley numbers K and L. All variables created in the
% construction are returned in a structure called OUT. 
%
% See also: vlt.neuro.reverse_correlation.hartley.build, vlt.neuro.reverse_correlation.hartley.check
%

M = hstruct.M;
angle = vlt.math.rad2deg(atan2(k,l));

[i] = findclosest(hstruct.F,sqrt(k^2+l^2)/M);
center = floor(size(hstruct.im_offscreen,2)/2);
if s==-1, % 180 degree phase shift
	center = center+round(1/(2*hstruct.F(i)))-1;
end;
selection = center + (-(M-1):(M+1));
im_big = repmat(hstruct.im_offscreen(i,selection),numel(selection),1);
im_big = im_big'; 

im_bigrot = imrotate(im_big,angle,'bilinear','crop');

if mod(hstruct.M,2)==0, % if even
	subselection = round(M/2) + (1:M);
else,
	subselection = round(M+1)/2 + (1:M); 
end;

im = im_bigrot(subselection,subselection);
%im_phase_out = im_big_phaserot(subselection,subselection);

%[l_,m_] = meshgrid(0:M-1,0:M-1);
%real_phase = mod((2*pi*(k.*l_+l.*m_)/M),2*pi);

out = workspace2struct;



return;
 % scratch
%im_big_phaserot = imrotate(im_big_phase,angle,'bilinear','crop');

if mod(hstruct.M,2)==0,
	advance = round( ((M-1-1e-6)/2)*0.5*(1-cos(4*vlt.math.deg2rad(-angle))))
else,
	advance = 0;
end;

%im_big_phase = repmat(hstruct.im_phase(i,selection),numel(selection),1);
%im_big_phase = im_big_phase';
