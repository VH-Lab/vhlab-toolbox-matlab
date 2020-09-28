function [rsp,rp,op,sigma,rn] = osi2oriparams2(osi, varargin)
% OSI2ORIPARAMS - Given an OSI, generate double gaussian parameters that has that osi index
%
%   [RSP,RP,OP,SIGMA,RN] = vlt.neuro.vision.oridir.osi2oriparams2(OSI, ...)
%
%   Given a requested OSI index value, where OSI is defined as 
%     (RESPONSE(PREFERRED) - RESPONSE(ORTHOGONAL))/RESPONSE(PREFERRED)
%   this function generates a set of double gaussian parameters that satisfies
%   the OSI.
%
%   By default, OP is 0, SIGMA is 20, RP and RN are equal. RP + RSP will be 10.
%   RSP will be set to whatever is necessary to make the OSI be fit.
%   
%   
%
%   One can add extra arguments as name/value pairs to modify the SIGMA, OP, and
%   RSP parameters of the double gaussian, for example:
%   [RSP,RP,OP,SIGMA,RN] = vlt.neuro.vision.oridir.osi2oriparams2(OSI, 'SIGMA',40)
%
%   One can use the following code to validate this function:
%      desired_index = [];
%      actual_index = [];
%      for i=0:0.1:1,
%          desired_index(end+1) = i;
%          [rsp,rp,op,sigma,rn] = vlt.neuro.vision.oridir.osi2oriparams2(i);
%          [dummy,shape] = vlt.fit.otfit_carandini_err([rsp rp op sigma rn],[0:22.5:360-22.5]);
%          actual_index(end+1) = vlt.neurovision.oridir.index.compute_orientationindex(0:22.5:360-22.5,shape);
%       end;
%       [desired_index' actual_index']
%
%   See also: vlt.fit.otfit_carandini

 % make a narrowly-tuned function 

op = 0;
sigma = 20;
rp = 10;
rn = 10;
rsp = 0;

vlt.data.assign(varargin{:});

extra_gaussian_1 = exp(-(180^2)/(2*sigma.^2));
extra_gaussian_2 = exp(-(90^2)/(2*sigma.^2)); 

%Rsp + Rp + Rn*eg1 == 10
%Rsp == 10 - Rp - Rn*eg1
%(Rp+Rsp+Rn*eg1-Rsp-(Rp+Rn)*eg2)/(Rp+Rsp+Rn*eg1) == OSI
%  simplify
%(Rp+Rn*eg1-(Rp+Rn)*eg2)/(Rp+Rsp+Rn*eg1) == OSI
%  Apply Rp == Rn
%(Rp+Rp*eg1-(2*Rp)*eg2)/(Rp+Rsp+Rp*eg1) == OSI
%  Substitute Rsp
%(Rp+Rp*eg1-(2*Rp)*eg2)/(Rp+(10-Rp-Rp*eg1)+Rp*eg1) == OSI
%  Simplify
%(Rp+Rp*eg1-(2*Rp)*eg2) == 10*OSI
% Combine like terms
%  Rp (1+eg1-2*eg2) == 10*OSI
%  Rp (1+eg1-2*eg2) == 10*OSI / (1+eg1-2*eg2)

if osi == 0,
	rp = 0;
	rn = 0;
	rsp = 10;
else,
	rp = 10*osi/(1+extra_gaussian_1-2*extra_gaussian_2);
	rn = rp;
	rsp = 10 - rp - rn*extra_gaussian_1;
end;

