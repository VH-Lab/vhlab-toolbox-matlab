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

c = 1 - rgb;
k = min(c);
if k==1
    m = [0 0 0];
else
    m = (c-k)./(1-k);
end
cmyk = [m k];

end