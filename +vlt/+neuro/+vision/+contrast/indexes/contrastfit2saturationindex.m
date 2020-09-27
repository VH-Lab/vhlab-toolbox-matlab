function si = contrastfit2saturationindex(contrast, responses)
% CONTRASTFIT2SATURATIONINDEX - Compute Saturation Index 
%
%   SI = vlt.neuro.vision.contrast.indexes.contrastfit2saturationindex(CONTRAST, RESPONSE)
%
%  Given contrast in 1 percent steps in CONTRAST, this function
%  computes the "saturation index" that is defined as:
%
%  SI = (Rmax - R(100)) / (Rmax - R(0))
%
%  This is the amount of "super saturation" at 100% contrast.
%
%  Units of contrast can be percent or from 0 to 1.
%
%  If Rmax == R(0), then the measure is undefined and the index that is
%  returned is NaN.
%
%  This index is called MI in Peirce 2007 (JoV)

if max(contrast)>90,  % units could be percent or 0-1
	hundred = vlt.data.findclosest(contrast,100);
else,
	hundred = vlt.data.findclosest(contrast,1);
end;

zero = vlt.data.findclosest(contrast,0);

Rmax = max(responses(zero:hundred));

si = (Rmax-responses(hundred))/(Rmax-responses(zero));

if isinf(si), si = NaN; end;
