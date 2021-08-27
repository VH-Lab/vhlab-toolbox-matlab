function out=build(M, kmax, lmax, normmax)
% BUILD - build a Hartley structure to rapidly draw Hartley stimuli
%
% HSTRUCT = vlt.neuro.reverse_correlation.hartley.build(M, KMAX, LMAX, NORM_MAX)
%
% Computes a structure that allows easy drawing (with rotation and repetition) of a Hartley
% stimulus from Ringach et al. 1997. It is compact in memory and can be used to give input
% to Psychtoolbox or other GPU renderers for fast drawing with minimal memory.
%
% The image rotation used here works best for M > 50 and for K,L < M/2. This will not
% faithfully reproduce the basis functions for M<50 or K,L near M, due to aliasing.
%
% 
%
% Inputs:
%    M is the number of pixels per edge of the image (the image is square).
%    KMAX is the number of Hartley components to use in X. Components from -KMAX...KMAX will be used.
%    LMAX is the number of Hartley components to use in Y. Components from -LMAX...LMAX will be used.
%    NORMMAX - components will only be included if they also are less than NORMMAX, where sqrt(K^2+L^2)<=NORMMAX
%
% See also: vlt.neuro.reverse_correlation.hartley.draw, vlt.neuro.reverse_correlation.hartley.hartley_image
% 

if nargin<4,
	normmax = Inf;
end;

F = []; % spatial frequencies
phase_center = []; % phase at center of rotated coordinates

for k=0:kmax,
	for l=k:lmax,
		if l~=0 & sqrt(k^2+l^2)<normmax,
			F(end+1) = sqrt(k^2+l^2)/M;
			phase_center(end+1) = mod(2*pi*(1/M)*(k*(M-1)/2+l*(M-1)/2), 2*pi);
		end;
	end;
end;

if mod(M,2)==0,
	pixel_coords = (-M-1):(2*M)-1+1;
else,
	pixel_coords = ((-M+1)/2):(M+(M-1)/2);
end;

if mod(M,2)==0, % even
	pixel_coords = (-2*M+1):(2*M);
else,
	pixel_coords = (-2*M):(2*M);
end;

[offX_mesh,offF_mesh] = meshgrid(pixel_coords,F);
off_phase = repmat(phase_center(:),1,numel(pixel_coords));
im_offscreen = cas(2*pi*offF_mesh.*offX_mesh+off_phase)/(sqrt(2)); % divide by square root of 2 to make output in [-1..1]


out = workspace2struct;
out = rmfield(out,{'k','l','offX_mesh','offF_mesh','off_phase'});

return;

 % scratch

[k_mesh,l_mesh] = meshgrid(-kmax:kmax,-lmax:lmax);
% F = sqrt(k_mesh.^2+l_mesh.^2); all spatial frequencies
 % orientations
o = atan2(k_mesh,l_mesh);


% advance = 1./(8*F_);
%im_phase = mod(2*pi*offy_mesh.*offx_mesh,2*pi); % phase
