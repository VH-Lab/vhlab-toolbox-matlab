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

rgb = 1 - (cmyk(1:3) + cmyk(4)*[1 1 1]);
rgb(find(rgb<0)) = 0;


