function out=build(M, kmax, lmax)
%
%

warning('not working yet');

[k_mesh,l_mesh] = meshgrid(-kmax:kmax,-lmax:lmax);

 % orientations
o = atan2(k_mesh,l_mesh);

% F = sqrt(k_mesh.^2+l_mesh.^2); all spatial frequencies

F_ = [];
for k=0:kmax,
	for l=k:lmax,
		if l~=0,
			F_(end+1) = sqrt(k^2+l^2)/M;
		end;
	end;
end;

advance = 1./(8*F_);
if mod(M,2)==0,
	pixel_coords = (-M-1):(2*M)-1+1;
else,
	pixel_coords = ((-M+1)/2):(M+(M-1)/2);
end;
[offx_mesh,offy_mesh] = meshgrid(pixel_coords,F_);
im_offscreen = cas(2*pi*offy_mesh.*offx_mesh)/(sqrt(2)); % divide by square root of 2 to make output in [-1..1]

out = workspace2struct;
out = rmfield(out,{'k','l','offx_mesh','offy_mesh'});
