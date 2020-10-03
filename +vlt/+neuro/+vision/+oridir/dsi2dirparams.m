function [rsp,rp,op,sigma,rn] = dsi2dirparams(dsi, varargin)
% DSI2DIRPARAMS - Given a DSI, generate double gaussian parameters that has that dsi index
%
%   [RSP,RP,OP,SIGMA,RN] = vlt.neuro.vision.oridir.dsi2dirparams(DSI, ...)
%
%   Given a requested DSI index value, where DSI is defined as 
%     (RESPONSE(PREFERRED) - RESPONSE(OPPOSITE))/RESPONSE(PREFERRED)
%   this function generates a set of double gaussian parameters that satisfies
%   the DSI.
%
%   By default, OP is 0, SIGMA is 20, RSP is 0, RP = 10. 
%
%   One can add extra arguments as name/value pairs to modify the SIGMA, OP, and
%   RSP parameters of the double gaussian, for example:
%   [RSP,RP,OP,SIGMA,RN] = vlt.neuro.vision.oridir.dsi2dirparams(DSI, 'SIGMA',40)
%
%   One can use the following code to validate this function:
%      desired_index = [];
%      actual_index = [];
%      for i=0:0.1:1,
%          desired_index(end+1) = i;
%          [rsp,rp,op,sigma,rn] = vlt.neuro.vision.oridir.dsi2dirparams(i);
%          [dummy,shape] = vlt.fit.otfit_carandini_err([rsp rp op sigma rn],[0:22.5:360-22.5]);
%          actual_index(end+1) = vlt.neurovision.oridir.index.compute_directionindex(0:22.5:360-22.5,shape);
%       end;
%       [desired_index' actual_index']
%
%   See also: vlt.fit.otfit_carandini

 % make a narrowly-tuned function 

op = 0;
sigma = 40;
rsp = 0;
rp = 10;

extra_gaussian = 2*exp(-(90^2)/(2*sigma.^2)); % how much above Rsp is orthogonal response?
extra_rp_gaussian = 1*exp(-(180^2)/(2*sigma.^2)); % how much above Rp/Rn are preferred/opposite responses?

rn = (dsi * (rsp + rp) - rp - rp*extra_rp_gaussian) ./ (-1 + extra_rp_gaussian - extra_rp_gaussian*dsi);

