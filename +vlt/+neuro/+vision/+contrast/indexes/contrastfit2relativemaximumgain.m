function [rmg,cvalue] = contrastfit2relativemaximumgain(contrast, responses)
% CONTRASTFIT2RELATIVEMAXIMUMGAIN - Compute relative maximum gain
%
%   [RMG,CVALUE] = vlt.neuro.vision.contrast.indexes.contrastfit2relativemaximumgain(CONTRAST, RESPONSE)
%
%  Given contrast in 1 percent steps in CONTRAST, this function
%  computes the relative maximum gain that is defined as:
%
%  max(dR/dC)
%
%  Units of contrast can be percent or from 0 to 1.  If they are percent
%  these units will be converted to 0-1, so that the units of dC are 
%  in fractions.
%
%  CVALUE is the contrast value where the maximum occurs.
%
%  See Heimel et al. 2005 (J Neurophysiology)

if max(contrast)>90,  % units could be percent or 0-1
	contrast = contrast / 100;
else,
end;

hundred = vlt.data.findclosest(contrast,1);
zero = vlt.data.findclosest(contrast,0);

responses = responses - responses(zero);

responses = responses ./ max(responses);

dR = diff(responses);
dC = diff(contrast);

[rmg,cvalue] = max(dR./dC);
