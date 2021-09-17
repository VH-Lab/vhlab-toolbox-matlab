function IM = hartley_image(s, kx, ky, M)
% HARTLEY_IMAGE - A Hartley image function
%
%  IM = vlt.neuro.reverse_correlation.hartley.hartley_image(S, KX, KY, M)
%
%  Returns the Hartley image defined by the equation
%
%  H(kx,ky) = s * vlt.math.cas(2*pi*(kx*l+ky*m)/M)
%   where l and m run from 0 to M-1.
%
%  S can be -1 or 1.
%
%  From Ringach et al., 1997

[l,m] = meshgrid(0:M-1,0:M-1);

IM = s * vlt.math.cas(2*pi*(kx.*l+ky.*m)/M);

