function [Rsp,Rp,Op,sig] = gaussfit_conv(direct,par,varargin)

% vlt.fit.otfit_carandini_conv Converts between real params and fitting params
%
%   [Rsp,Rp,Op,sig]=GUASSFIT_CONV(DIR,P,VARARGIN)
%
%  **This is really an internal function.  Only read if you're interested
%  in modifying vlt.fit.gaussfit.**
%  
%  Converts between the real parameters in the carandini fitting
%  function and those used by Matlab to find the minimum in the error
%  function.  For example, if the user specifies that Rsp must be
%  in the interval [0 10], then the fitting variable Rsp_ will take
%  values from -realmax to realmax but this value will be mapped onto
%  the interval [0 10]. 
%
%  DIR indicates direction of conversion.  'TOREAL' converts from
%  fitting variables to real, whereas 'TOFITTING' converts from
%  real variables to fitting variables.
%
%  The variable arguments, given in name/value pairs, are used to
%  specify restrictions.
%    Valid name/value pairs:
%     'widthint', e.g., [15 180]              sig must be in given interval
%                                                 (default no restriction)
%     'spontfixed',  e.g., 0                  Rsp fixed to given value
%                                                 (default is not fixed)
%     'spontint', [0 10]                      Rsp must be in given interval
%                                                 (default is no restriction)
%     'data', [obs11 obs12 ...; obs21 .. ;]   Observations to compute error
%
%  See also:  vlt.fit.gaussfit, vlt.fit.gaussfit_err, vlt.fit.otfit_carandini, vlt.fit.otfit_carandini_err


spontfixed = NaN;
widthint = NaN;
spontint = NaN;
data = NaN;

vlt.data.assign(varargin{:});

s=0; % shift variable; if Rsp is fixed then only 3 vars to search over
     % need to check to see if parameters actually 3 vars or 4

if strcmp(direct,'TOREALFORFIT'),
	if isnan(spontfixed),
		if isnan(spontint),
			Rsp = par(1);
		else, Rsp=spontint(1)+diff(spontint)/(1+abs(par(1)));
		end;
	else, Rsp = spontfixed; s = -1;
	end;

	Rp=abs(par(2+s)); Op=par(3+s);

	if isnan(widthint),
		sig = abs(par(4+s));
	else, sig=widthint(1)+diff(widthint)/(1+abs(par(4+s)));
	end;
elseif strcmp(direct,'TOREAL'),
	if isnan(spontfixed),
		if isnan(spontint),
			Rsp = par(1);
		else, Rsp=spontint(1)+diff(spontint)/(1+abs(par(1)));
		end;
	else, Rsp = spontfixed; s = -1;
	end;
	Rp = abs(par(2+s)); Op = par(3+s);
	if isnan(widthint), sig = abs(par(4+s));
	else, sig=widthint(1)+diff(widthint)/(1+abs(par(4+s)));
	end;
	
elseif strcmp(direct,'TOFITTING'),
	if isnan(spontfixed),
		if isnan(spontint),
			Rsp=par(1);
		else, 
			if par(1)==spontint(1),
				Rsp = (spontint(2)-par(1))/(par(1)-spontint(1)+1e-12);
			else, Rsp = (spontint(2)-par(1))/(par(1)-spontint(1));
			end;
		end;
	else, Rsp = spontfixed; s = -1;
	end;

	if isnan(widthint), sig=par(4+s);
	else,
		if par(4+s)==widthint(1),
			sig=(widthint(2)-par(4+s))/(par(4+s)-widthint(1)+1e-12);
		else,
			sig=(widthint(2)-par(4+s))/(par(4+s)-widthint(1));
		end;
	end;
	Rp=par(2+s); Op=par(3+s); % no adjustment needed
else, error(['Conv. direction ' direct ' unknown.']);
end;
