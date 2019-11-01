function [err,Rfit] = otfit_carandini_err2(par,angles,varargin)

% OTFIT_CARANDINI_ERR Computes error of Carandini/Ferster orientation fit
%
%   [ERR, RFIT]=OTFIT_CARANDINI_NEWS_ERR2(P,ANGLES,VARARGIN) 
%
%   This function computes the error of the Carandini/Ferster orientation
%   RFIT(O)=Rsp+Rp*exp(-(O-Op)^2/2*sig^2)+Rn*(exp(-(O-Op-180)^2)/s*sig^2)
%   where O is an orientation angle.  ANGLES is a vector list of angles to
%   be evaluated.  If observations are provided (see below) then the
%   squared error ERR is computed.  Otherwise ERR is zero.
%
%    The variable arguments, given in name/value pairs, can be used
%    to specify the mode.
%    Valid name/value pairs:
%     'widthint', e.g., [15 180]              sig must be in given interval
%                                                 (default no restriction)
%     'spontfixed',  e.g., 0                  Rsp fixed to given value
%                                                 (default is not fixed)
%     'spontint', [0 10]                      Rsp must be in given interval
%                                                 (default is no restriction)
%     'OnOffint', e.g., [140 220]             OnOff is offset from Op and
%                                                 must be in given interval
%                                                 (default is [179 181])
%     'data', [obs11 obs12 ...; obs21 .. ;]   Observations to compute error
%
%    P = [ Rsp Rp Op sig Rn OnOff] are parameters, where Rsp is the spontaneous
%   response, Rp is the response at the preferred orientation, Op is the
%   preferred angle, sig is the width of the tuning, and Rn is the response
%   180 degrees away from the preferred angle.
%
%   See also:  OTFIT_CARANDINI

data = NaN;
spontfixed = NaN;

needconvert = 0;

assign(varargin{:});

err=0;


  % get parameters from fitting inputs
if needconvert, % do we need to convert for fit?
	[Rsp,Rp,Op,sig,Rn,OnOff]=otfit_carandini_conv2('TOREALFORFIT',par,varargin{:});
else,
	if isnan(spontfixed), % is par 4 or 5 entries?
		Rsp = par(1); Rp=par(2); Op=par(3); sig=par(4); Rn=par(5);OnOff=par(6);
	else, Rsp = spontfixed;Rp=par(1); Op=par(2); sig=par(3); Rn=par(4);OnOff=par(5);
	end;
end;

  % rotate data so optimal is 90, then use pure exponential

%fangles = mod(angles+90-Op,360); % shift so 90 is always optimal
                                 % necessary because exp's are not circular
								 % for example. if best angle is 0 deg and
								 % width is 30 deg, then half the peak will be
								 % from 360...330.  Formula doesn't account for this.
								 % Making squared diff's in exp on the 0..360 circle
								 % doesn't help b/c odd shapes are possible.
								 % There is a discontinuity in this solution but it is
								 % not at the peak regions which is preferable to the
								 % no shift case where it can be in the middle of the peak.

Rfit = Rsp+Rp*exp(-angdiff(Op-angles).^2/(2*sig^2))+Rn*exp(-angdiff(OnOff+Op-angles).^2/(2*sig^2));
%Rfit = Rsp+Rp*exp(-angdiff(90-fangles).^2/(2*sig^2))+Rn*exp(-angdiff(OnOff+90-fangles).^2/(2*sig^2));
%Rfit = Rsp+Rp*exp(-(90-fangles).^2/(2*sig^2))+Rn*exp(-(OnOff+90-fangles).^2/(2*sig^2));

if ~isnan(data),
	d = (data-repmat(Rfit,size(data,1),1));
	err=err+(sum(sum(abs(d.*d))));
end;



