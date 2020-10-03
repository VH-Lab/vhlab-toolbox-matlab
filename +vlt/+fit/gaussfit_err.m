function [err,Rfit] = gaussfit_err(par,angles,varargin)

% vlt.fit.gaussfit_err Computes error of gaussian fit
%
%   [ERR, RFIT]=vlt.fit.gaussfit_err(P,ANGLES,VARARGIN) 
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
%     'data', [obs11 obs12 ...; obs21 .. ;]   Observations to compute error
%
%    P = [ Rsp Rp Op sig Rn] are parameters, where Rsp is the spontaneous
%   response, Rp is the response at the preferred orientation, Op is the
%   preferred angle, sig is the width of the tuning, and Rn is the response
%   180 degrees away from the preferred angle.
%
%   See also:  vlt.fit.gaussfit vlt.fit.otfit_carandini

data = NaN;
spontfixed = NaN;

needconvert = 0;

vlt.data.assign(varargin{:});

err=0;


  % get parameters from fitting inputs
if needconvert, % do we need to convert for fit?
	[Rsp,Rp,Op,sig]=vlt.fit.gaussfit_conv('TOREALFORFIT',par,varargin{:});
else,
	if isnan(spontfixed), % is par 3 or 4 entries?
		Rsp = par(1); Rp=par(2); Op=par(3); sig=par(4);
	else, Rsp = spontfixed;Rp=par(1); Op=par(2); sig=par(3);
	end;
end;

Rfit = Rsp+Rp*exp(-((angles-Op).^2)/(2*sig.^2));

if ~isnan(data),
	d = (data-repmat(Rfit,size(data,1),1));
	err=err+(sum(sum(abs(d.*d))));
end;

%keyboard;
