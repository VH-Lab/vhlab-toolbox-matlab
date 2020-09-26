function [Rsp,Rp,Ot,sigm,Rn,OnOff,fitcurve,er,R2]=otfit_carandini2(angles,sponthint,maxresphint,otprefhint,widthhint,varargin)

% vlt.fit.otfit_carandini Fits orientation curves like Carandini/Ferster 2000
%
%  [Rsp,Rp,Op,sigm,Rn,OnOff,FITCURVE,ERR,R2]=vlt.fit.otfit_carandini(ANGLES,...
%         SPONTHINT, MAXRESPHINT, OTPREFHINT, WIDTHHINT,'DATA',DATA,...) 
%
%  Finds the best fit to the function
%
%  R=Rsp+Rp*EXP(-(X-Op)^2)/(2*sig^2))+Rn*EXP(-(X-On)^2/(2*sig^2))
%  where R is the response, Rsp is the spontaneous response, Rp is 
%  the response at the preferred angle, Op is the preferred angle,
%  sigm is the tuning width, Rn is the firing rate at 180+Op,
%  OnOff is the offset of the null angle from the preferred.
%
%  One can restrict the range of these parameters by providing
%  descriptor/interval pairs as additional arguments (e.g.,
%  'OnOffInt',[130 230] ).  See vlt.fit.otfit_carandini_conv2 for a list
%  of interval names.
%
%  ERR is the squared error between the fit and the data.
%
%  R2 is the R^2 value of the fit.
%
%  
%  FITCURVE is the fit function at 1 degree intervals (0:1:359).

spontfixed = NaN;
vlt.data.assign(varargin{:});

Po = [sponthint maxresphint otprefhint widthhint maxresphint 180];

if ~isnan(spontfixed), Po = Po(2:end); end;

[Rsp_,Rp_,Ot_,sigm_,Rn_,OnOff_]=vlt.fit.otfit_carandini_conv2('TOFITTING',Po,varargin{:});

Po = [ Rsp_ Rp_ Ot_ sigm_ Rn_ OnOff_];
if ~isnan(spontfixed), Po = Po(2:end); end;

 % starting point
options= optimset('Display','off','MaxFunEvals',10000,'TolX',1e-6);
%options = foptions;
%options(1)=0; options(2)=1e-6; options(14)=10000;
%Pf = fmins('vlt.fit.otfit_carandini_err2',Po,options,[],angles,varargin{:},'needconvert',1);
vlt.data.assign(varargin{:});
searchArg = '@(x) vlt.fit.otfit_carandini_err2(x,angles,';
for i=1:2:length(varargin),
	searchArg = [searchArg '''' varargin{i} ''',' varargin{i} ','];
end;
needconvert = 1;
searchArg = [searchArg '''needconvert'',needconvert)'];

Pf = eval(['fminsearch(' searchArg ',Po,options);']);

[Rsp,Rp,Ot,sigm,Rn,OnOff] = vlt.fit.otfit_carandini_conv2('TOREAL',Pf,varargin{:});

if ~isnan(spontfixed), er = vlt.fit.otfit_carandini_err2([Rp Ot sigm Rn OnOff],angles,varargin{:});
else, er = vlt.fit.otfit_carandini_err2([Rsp Rp Ot sigm Rn OnOff],angles,varargin{:});
end;

fitcurve = [];
if nargout>5,
	for i=1:length(varargin),
		if strcmp(varargin{i},'data'), break; end;
	end;
	varargin = {varargin{setdiff(1:length(varargin),[i i+1])}};
	[d,fitcurve]=vlt.fit.otfit_carandini_err2(Pf,0:359,varargin{:},'needconvert',1);
end;

R2 = 1 - sum(er)/(sum((data-mean(data)).^2));
