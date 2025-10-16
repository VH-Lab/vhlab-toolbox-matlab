function rgb = cmyk2rgb(cmyk)
% CMYK2RGB - Convert CMYK to RGB
%
%  RGB = CMYK2RGB(COLOR)
%
%  Converts from CMYK color space to RGB space.
%
%  Color values must be in 0..1.
%
%  See also:  RGB2CMYK
%
%  Derived from code posted to the web by
%  Ch Begler at Scripps Institute of Oceanography
%

arguments
	cmyk (1,4) double {mustBeGreaterThanOrEqual(cmyk,0), mustBeLessThanOrEqual(cmyk,1)}
end

c = cmyk(1); m = cmyk(2); y = cmyk(3); k = cmyk(4);
r = (1 - c) * (1 - k);
g = (1 - m) * (1 - k);
b = (1 - y) * (1 - k);
rgb = [r g b];


