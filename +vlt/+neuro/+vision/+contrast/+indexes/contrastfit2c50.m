function c50 = contrastfit2c50(contrast, responses)
% CONTRASTFIT2C50- Compute Half maximum
%
%   C50 = vlt.neuro.vision.contrast.indexes.contrastfit2c50(CONTRAST, RESPONSE)
%
%  Given contrast in 1 percent steps in CONTRAST, this function
%  computes the half maximum value that is defined as:
%
%  value of C such that R(C50) = 0.5 * max(R)
%
%  Units of contrast can be percent or from 0 to 1.
%
%  See Heimel et al. 2005 (Journal of Neurophysiology)

if max(contrast)>90,  % units could be percent or 0-1
	hundred = vlt.data.findclosest(contrast,100);
else,
	hundred = vlt.data.findclosest(contrast,1);
end;


zero = vlt.data.findclosest(contrast,0);

responses = responses - responses(zero);

Rmax = max(responses(zero:hundred));

[dummy,C50index] = find(responses>=0.5*Rmax,1);

c50 = contrast(C50index);
