function Vl = luminous_efficacy(wavelengths, scotopic)
% LUMINOUS_EFFICACY - The luminous efficacy (in lm/watt) vs. wavelength  
%
%  VL = vlt.optics.optics_tables.luminous_efficacy(WAVELENGTHS)
%    or
%  VL = vlt.optics.optics_tables.luminous_efficacy(WAVELENGTHS, SCOTOPIC)
%
%  Returns the luminous efficacy for the requested WAVELENGTHS (in nm).
%  If the second argument SCOTOPIC is provided and it is 1, then the scotopic (dark vision/rod vision)
%  values are returned. Otherwise, PHOTOTOPIC vision (light vision) values are provided.
%
%  The luminous efficacy is the conversion factor between radiated light energy in
%  watts and the brightness as experienced by the human visual system, which has units of 
%  lumens.  
%
%  For example, if you have a 5mW laser beam at 680nm, the luminous flux is 
%  lf = (0.005 W) * vlt.optics.optics_tables.luminous_efficacy(680) (lm/watt) = 0.0581 lm
%  If you have a 5mW laser beam at 630nm, the luminous flux is 
%  lf = (0.005 W) * vlt.optics.optics_tables.luminous_efficacy(630) (lm/watt) = 0.9050 lm
%  The latter is better because 630nm has a stronger overlap with visual perception.
%
%  Note: Values of VL for wavelengths < 380nm and greater than 770nm will be 0 by default.
%
%  Source:  http://hyperphysics.phy-astr.gsu.edu/hbase/vision/efficacy.html
%  Their source: Williamson & Cummins, Light and Color in Nature and Art, Wiley, 1983.

sco = 0;
if nargin==2,
	sco = scotopic;
end;

if sco,
	Vl = vlt.optics.optics_tables.optics_table(wavelengths,'scotopic_lumens.txt');
else,
	Vl = vlt.optics.optics_tables.optics_table(wavelengths,'photopic_lumens.txt');
end;
