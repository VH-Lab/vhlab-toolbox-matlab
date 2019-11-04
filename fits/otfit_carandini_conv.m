function [Rsp,Rp,Op,sig,Rn] = otfit_carandini_conv(direct,par,varargin)

% OTFIT_CARANDINI_CONV Converts between real params and fitting params
%
%   [Rsp,Rp,Op,sig,Rn]=OTFIT_CARANDINI_CONV(DIR,P,VARARGIN)
%
%  **This is really an internal function.  Only read if you're interested
%  in modifying OTFIT_CARANDINI.**
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
%     'Rpint', e.g., [0 2*maxdata]            Rp must bein given interval
%                                                 (default is no restriction)
%     'Rnint', e.g., [0 2*maxdata]            Rp must bein given interval
%                                                 (default is no restriction)
%     'data', [obs11 obs12 ...; obs21 .. ;]   Observations to compute error
%
%     'stddev', [stddev1 stddev2 stddev3 ...] Standard deviation; if provided,
%                                                 squared error is normalized
%                                                 by standard deviation
%
%  See also:  OTFIT_CARANDINI, OTFIT_CARANDINI_ERR


spontfixed = NaN;
widthint = NaN;
spontint = NaN;
Rpint =NaN;
Rnint = NaN;
data = NaN;
stddev = NaN;

assign(varargin{:});

s=0; % shift variable; if Rsp is fixed then only 4 vars to search over
     % need to check to see if parameters actually 4 vars or 5

if strcmp(direct,'TOREALFORFIT'),
	if isnan(spontfixed),
		if isnan(spontint),
			Rsp = par(1);
		else, Rsp=spontint(1)+diff(spontint)/(1+abs(par(1)));
		end;
	else, Rsp = spontfixed; s = -1;
	end;

        if isnan(Rpint), Rp=abs(par(2+s));
        else, Rp=Rpint(1)+diff(Rpint)/(1+abs(par(2+s)));
        end;
        if isnan(Rnint), Rn=abs(par(5+s));
        else, Rn=Rnint(1)+diff(Rnint)/(1+abs(par(5+s)));
        end;

	Op=mod(par(3+s),360);

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

	if isnan(widthint), sig = abs(par(4+s));
	else, sig=widthint(1)+diff(widthint)/(1+abs(par(4+s)));
	end;

        if isnan(Rpint), Rp=abs(par(2+s));
        else, Rp=Rpint(1)+diff(Rpint)/(1+abs(par(2+s)));
        end;
        if isnan(Rnint), Rn=abs(par(5+s));
        else, Rn=Rnint(1)+diff(Rnint)/(1+abs(par(5+s)));
        end;
	
        if Rp>Rn, % do we need to swap Rp,Rn?
                Op=mod(par(3+s),360);
        else, Rn_ = Rp; Rp = Rn; Rn = Rn_; ;Op=mod(par(3+s)+180,360);
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
        if isnan(Rpint), Rp=par(2+s);
        else,
                if par(2+s)==Rpint(1),
                        Rp=(Rpint(2)-par(2+s))/(par(2+s)-Rpint(1)+1e-12);
                else, Rp=(Rpint(2)-par(2+s))/(par(2+s)-Rpint(1)+1e-12);
                end;
        end;
        if isnan(Rnint), Rp=par(5+s);
        else,
                if par(5+s)==Rnint(1),
                        Rn=(Rnint(2)-par(5+s))/(par(5+s)-Rnint(1)+1e-12);
                else, Rn=(Rnint(2)-par(5+s))/(par(5+s)-Rnint(1)+1e-12);
                end;
        end;
	Op=par(3+s); % no adjustment needed
else, error(['Conv. direction ' direct ' unknown.']);
end;
