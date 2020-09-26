function [Rsp,Rp,Ot,sigm,fitcurve,er,R2]=otfit_carandini0(angles,sponthint,maxresphint,otprefhint,widthhint,varargin)

% vlt.fit.otfit_carandini0 Fits orientation curves like Carandini/Ferster 2000
%
%  [Rsp,Rp,Op,sigm,FITCURVE,ERR]=vlt.fit.otfit_carandini0(ANGLES,...
%         SPONTHINT, MAXRESPHINT, OTPREFHINT, WIDTHHINT,'DATA',DATA) 
%
%  Finds the best fit to the function
%
%  R=Rsp+Rp*EXP(-(X-Op)^2)/(2*sig^2))+Rp*EXP(-(X-Op+180)^2/(2*sig^2))
%  where R is the response, Rsp is the spontaneous response, Rp is 
%  the response at the preferred orientation, Op is the preferred angle,
%  sigm is the tuning width.
%
%  This function differs from vlt.fit.otfit_carandini in that the response
%  180 degrees away from Op is constrained to be Rp.  In
%  vlt.fit.otfit_carandini, it can have its own value Rn.
%
%  
%  
%  FITCURVE is the fit function at 1 degree intervals (0:1:359).

spontfixed = NaN;
vlt.data.assign(varargin{:});

Po = [sponthint maxresphint otprefhint widthhint maxresphint];

if ~isnan(spontfixed), Po = Po(2:end); end;

[Rsp_,Rp_,Ot_,sigm_]=vlt.fit.otfit_carandini_conv0('TOFITTING',Po,varargin{:});

Po = [ Rsp_ Rp_ Ot_ sigm_ ];
if ~isnan(spontfixed), Po = Po(2:end); end;

 % starting point
options= optimset('Display','off','MaxFunEvals',10000,'TolX',1e-6);
%options = foptions;
%options(1)=0; options(2)=1e-6; options(14)=10000;
%Pf = fmins('vlt.fit.otfit_carandini_err',Po,options,[],angles,varargin{:},'needconvert',1);
vlt.data.assign(varargin{:});
searchArg = '@(x) vlt.fit.otfit_carandini_err0(x,angles,';
for i=1:2:length(varargin),
	searchArg = [searchArg '''' varargin{i} ''',' varargin{i} ','];
end;
needconvert = 1;
searchArg = [searchArg '''needconvert'',needconvert)'];

Pf = eval(['fminsearch(' searchArg ',Po,options);']);

[Rsp,Rp,Ot,sigm] = vlt.fit.otfit_carandini_conv0('TOREAL',Pf,varargin{:});

if ~isnan(spontfixed), er = vlt.fit.otfit_carandini_err0([Rp Ot sigm],angles,varargin{:});
else, er = vlt.fit.otfit_carandini_err0([Rsp Rp Ot sigm],angles,varargin{:});
end;

fitcurve = [];
if nargout>5,
	for i=1:length(varargin),
		if strcmp(varargin{i},'data'), break; end;
	end;
	varargin = {varargin{setdiff(1:length(varargin),[i i+1])}};
	[d,fitcurve]=vlt.fit.otfit_carandini_err0(Pf,0:359,varargin{:},'needconvert',1);
end;

R2 = 1 - sum(er)/(sum((data-mean(data)).^2));
