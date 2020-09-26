function [Rsp,Rp,Ot,sigm,fitcurve,er]=gaussfit(angles,sponthint,maxresphint,otprefhint,widthhint,varargin)

% vlt.fit.gaussfit Fits data to a Gaussian
%
%  [Rsp,Rp,P,sigm,FITCURVE,ERR]=vlt.fit.gaussfit(VALUES,...
%         SPONTHINT, MAXRESPHINT, OTPREFHINT, WIDTHHINT,'DATA',DATA) 
%
%  Finds the best fit to the function
%
%  R=Rsp+Rp*EXP(-(X-P)^2)/(2*sigm^2))
%  where R is the response, Rsp is the spontaneous response, Rp is 
%  the response at the preferred value, P is the preferred value,
%  sigm is the tuning width.
%
%  VALUES are the values of X that are measured.
%  DATA is the response for each value in VALUES.
%  
%  FITCURVE is the fit function at 1 value intervals min:max.
%
%  ERR is the mean squared error.

spontfixed = NaN;
vlt.data.assign(varargin{:});

Po = [sponthint maxresphint otprefhint widthhint maxresphint];

if ~isnan(spontfixed), Po = Po(2:end); end;

[Rsp_,Rp_,Ot_,sigm_]=vlt.fit.gaussfit_conv('TOFITTING',Po,varargin{:});

Po = [ Rsp_ Rp_ Ot_ sigm_ ];
if ~isnan(spontfixed), Po = Po(2:end); end;

 % starting point
options= optimset('Display','off','MaxFunEvals',10000,'TolX',1e-6);
%options = foptions;
%options(1)=0; options(2)=1e-6; options(14)=10000;
%Pf = fmins('vlt.fit.gaussfit_err',Po,options,[],angles,varargin{:},'needconvert',1);
vlt.data.assign(varargin{:});
searchArg = '@(x) vlt.fit.gaussfit_err(x,angles,';
for i=1:2:length(varargin),
	searchArg = [searchArg '''' varargin{i} ''',' varargin{i} ','];
end;
needconvert = 1;
searchArg = [searchArg '''needconvert'',needconvert)'];

Pf = eval(['fminsearch(' searchArg ',Po,options);']);

[Rsp,Rp,Ot,sigm] = vlt.fit.gaussfit_conv('TOREAL',Pf,varargin{:});

if ~isnan(spontfixed), er = vlt.fit.gaussfit_err([Rp Ot sigm],angles,varargin{:});
else, er = vlt.fit.gaussfit_err([Rsp Rp Ot sigm],angles,varargin{:});
end;

fitcurve = [];
if nargout>4,
	for i=1:length(varargin),
		if strcmp(varargin{i},'data'), break; end;
	end;
	varargin = {varargin{setdiff(1:length(varargin),[i i+1])}};
	[d,fitcurve]=vlt.fit.gaussfit_err(Pf,min(angles):max(angles),varargin{:},'needconvert',1);
end;
