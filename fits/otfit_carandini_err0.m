function [err,Rfit] = otfit_carandini_err0(par,angles,varargin)

% OTFIT_CARANDINI_ERR0 Computes error of Carandini/Ferster orientation fit
%
%   [ERR, RFIT]=OTFIT_CARANDINI_NEWS_ERR0(P,ANGLES,VARARGIN) 
%
%   This function computes the error of the Carandini/Ferster orientation
%   RFIT(O)=Rsp+Rp*exp(-(O-Op)^2/2*sig^2)+Rp*(exp(-(O-Op-180)^2)/s*sig^2)
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
%     'data', [obs11 obs12 ...; obs21 .. ;]   Observations to compute error
%     'stddev', [stddev1 stddev2 ... ]        Standard deviatiation (optional)
%                                                 If provided, then squared
%                                                 error will be normalized by
%                                                 the variance.
%
%    P = [ Rsp Rp Op sig ] are parameters, where Rsp is the spontaneous
%   response, Rp is the response at the preferred orientation, Op is the
%   preferred angle, sig is the width of the tuning, and Rp is the response
%   180 degrees away from the preferred angle.
%
%   See also:  OTFIT_CARANDINI0

data = NaN;
spontfixed = NaN;

needconvert = 0;

assign(varargin{:});

if ~exist('stddev'),
	stddev = ones(size(data));
else, stddev = repmat(stddev,size(data,1),1);
end;

err=0;


  % get parameters from fitting inputs
if needconvert, % do we need to convert for fit?
	[Rsp,Rp,Op,sig]=otfit_carandini_conv0('TOREALFORFIT',par,varargin{:});
else,
	if isnan(spontfixed), % is par 3 or 4 entries?
		Rsp = par(1); Rp=par(2); Op=par(3); sig=par(4);
	else, Rsp = spontfixed;Rp=par(1); Op=par(2); sig=par(3);
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

                                                                 % REVISION TO ABOVE: If you limit the Rp and Rsp,
                                                                 % then weird behavior disappears, so switching back
                                                                 % to ANGDIFF

Rfit = Rsp+Rp*exp(-angdiff(Op-angles).^2/(2*sig^2))+Rp*exp(-angdiff(180+Op-angles).^2/(2*sig^2));
%Rfit = Rsp+Rp*exp(-(90-fangles).^2/(2*sig^2))+Rp*exp(-(270-fangles).^2/(2*sig^2));
%Rfit = Rsp+Rp*exp(-angdiff(90-fangles).^2/(2*sig^2))+Rp*exp(-angdiff(270-fangles).^2/(2*sig^2));



if ~isnan(data),
	d = (data-repmat(Rfit,size(data,1),1))./stddev;
	err=err+(sum(sum(abs(d.*d))));
end;

function D = angdiff(a)
D=min(abs([a;a+360;a-360]));

