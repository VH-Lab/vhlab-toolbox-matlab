function cmyk = rgb2cmyk(rgb)
% RGB2CMYK - Convert RGB to CMYK
%
%  CMYK = vlt.colorspace.rgb2cmyk(RGB)
%
%  Converts from RGB color space to CMYK space.
%
%  Color values must be in 0..1.
%
%  See also:  vlt.colorspace.cmyk2rgb
%
%  Derived from code posted to the web by
%  Ch Begler at Scripps Institute of Oceanography
%  

cmyk = 1 - rgb;
cmyk = [cmyk min(cmyk)];
cmyk(find(cmyk<0)) = 0;
cmyk(find(cmyk>1)) = 1;


