function rgb = cmyk2rgb(cmyk)
% CMYK2RGB - Convert CMYK to RGB
%
%  RGB = vlt.colorspace.cmyk2rgb(COLOR)
%
%  Converts from CMYK color space to RGB space.
%
%  Color values must be in 0..1.
%
%  See also:  vlt.colorspace.rgb2cmyk
%
%  Derived from code posted to the web by
%  Ch Begler at Scripps Institute of Oceanography
%  

c = cmyk(1); m = cmyk(2); y = cmyk(3); k = cmyk(4);
r = (1 - c) * (1 - k);
g = (1 - m) * (1 - k);
b = (1 - y) * (1 - k);
rgb = [r g b];


