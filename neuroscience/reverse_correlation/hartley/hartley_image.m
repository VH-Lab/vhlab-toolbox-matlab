function IM = hartley_image(kx, ky, M)
% HARTLEY_IMAGE - A Hartley image function
%  IM = HARTLEY_IMAGE(KX, KY, M)
%
%  Returns the Hartley image defined by the equation
%
%  H(kx,ky) = cas(2*pi*(kx*l+ky*m)/M)
%   where l and m run from 0 to M-1.
%
%  From Ringach et al., 1997

[l,m] = meshgrid(0:M-1,0:M-1);

IM = cas(2*pi*(kx.*l+ky.*m)/M);
