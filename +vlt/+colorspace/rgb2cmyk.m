function cmyk = rgb2cmyk(rgb)
% RGB2CMYK - Convert RGB to CMYK
%
%  CMYK = RGB2CMYK(RGB)
%
%  Converts from RGB color space to CMYK space.
%
%  Color values must be in 0..1.
%
%  See also:  CMYK2RGB
%
%  Derived from code posted to the web by
%  Ch Begler at Scripps Institute of Oceanography
%

arguments
	rgb (1,3) double {mustBeGreaterThanOrEqual(rgb,0), mustBeLessThanOrEqual(rgb,1)}
end

k = 1 - max(rgb);
if k == 1
    c = 0;
    m = 0;
    y = 0;
else
    c = (1-rgb(1)-k) / (1-k);
    m = (1-rgb(2)-k) / (1-k);
    y = (1-rgb(3)-k) / (1-k);
end
cmyk = [c m y k];


