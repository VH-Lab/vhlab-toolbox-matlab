function di = fit2fitdibr(fitparams, blank, resp)

% vlt.neuro.vision.oridir.index.fit2fitdibr - Direction index from double gaussian fit (blank rectified) 
%
%  DSI = vlt.neuro.vision.oridir.index.fit2fitdibr(FITPARAMS, BLANKRESP)
%
%  Computes the "direction selectivity index", or the fraction of the total response
%  that is in the preferred direction compared to the opposite direction.
%
%  FITPARAMS is a 5-value vector describing a double gaussian fit to a
%  direction tuning curve (FITPARAMS(1) is offset, FITPARAMS(2) is weight
%  of first gaussian peak, FITPARAMS(3) is the peak tuning position,
%  FITPARAMS(4) is the variance around the peak, FITPARAMS(%) is the
%  weight of the 'null' direction peak):
%  Resp = -BLANK + fitparams(1)+...
%    fitparams(2)*exp(-vlt.math.angdiff(fitparams(3)-angs).^2/(2*fitparams(4)^2)) +...
%    fitparams(5)*exp(-vlt.math.angdiff(fitparams(3)+180-angs).^2/(2*fitparams(4)^2));
%
%  The DSI is defined as DSI = (Rpref - Rnull) / Rpref
%
%  See also: vlt.fit.otfit_carandini, vlt.neuro.vision.oridir.index.fit2fitoi, vlt.neuro.vision.oridir.index.fit2fitdibr



angs = 0:359;

R=fitparams(1)+...
   fitparams(2)*exp(-vlt.math.angdiff(fitparams(3)-angs).^2/(2*fitparams(4)^2)) +...
   fitparams(5)*exp(-vlt.math.angdiff(fitparams(3)+180-angs).^2/(2*fitparams(4)^2));

OtPi = vlt.data.findclosest(0:359,fitparams(3));
OtNi = vlt.data.findclosest(0:359,mod(fitparams(3)+180,360));

di = (R(OtPi)-R(OtNi))/(R(OtPi)-min(R(OtNi),blank));
%di = (R(OtPi)-R(OtNi))/(R(OtPi)-blank);

%di = (R(OtPi)-R(OtNi))/(R(OtPi)+R(OtNi));

% use Hotelling's T^2 test to see if vectorized points deviate from 0,0
% allresps = resp'; angles = 0:45:360-45;
% % remove any NaN's
% notnans = find(0==isnan(mean(allresps')));
% allresps = allresps(notnans,:);
% if isempty(allresps), allresps = nanmean(resp'); end;
% if size(allresps,1)>0,
% 	% in direction space
% 	vecdirresp = (allresps*transpose(exp(sqrt(-1)*mod(angles*pi/180,2*pi))));
% 	[h3,vecdirp]=vlt.stats.hotellingt2test([real(vecdirresp) imag(vecdirresp)],[0 0]);
% 	vecdirpref = mod(180/pi*angle(mean(vecdirresp)),360);
% 	vecdirmag = abs(mean(vecdirresp));
% 	di = abs(mean(vecdirresp))/max(mean(allresps));
%  else, di = [];
%  end;
%  
%  if length(di)~=1, keyboard; end;
