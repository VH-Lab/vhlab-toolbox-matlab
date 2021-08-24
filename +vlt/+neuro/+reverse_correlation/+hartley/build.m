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
[offx,offy] = meshgrid(1:3*M+1,F_);
im_offscreen = cos(2*pi*offy.*offx);

out = workspace2struct;
out = rmfield(out,{'k','l'});
