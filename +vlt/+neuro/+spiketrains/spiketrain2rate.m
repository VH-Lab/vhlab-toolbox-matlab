function rate = spiketrain2rate(spiketrain, dt, blur, varargin)
% SPIKETRAIN2RATE - compute a 'blurred' spike rate from 0/1 spike train
%
% RATE = vlt.neuroscience.spiketrains.spiketrain2rate(SPIKETRAIN, DT, BLUR, ...)
%
% Given a vector of 0/1 binned SPIKETRAIN data and the sampling interval DT
% of the SPIKETRAIN, estimate a RATE of the spiking process by blurring with
% a parameter BLUR.
%
% This function takes extra parameters as name/value pairs that modify its behavior:
% Parameter (default)        | Description
% -----------------------------------------------------------------------------
% BlurFunc ('gaussian')      | The blur function to use. Default is 'gaussian'.
%
% See also: vlt.data.namevaluepair, vlt.neuroscience.spiketrains.spiketimes2bins
%
%
% Example:
%   dt = 0.001; t_start = 0; t_end = 50/2;
%   maxrate = 50; tFreq = 2; phase = 0; rate_offset = 20;
%   ST = vlt.neuroscience.spiketrains.spiketrain_sinusoidal(maxrate,tFreq,phase,rate_offset,t_start,t_end,dt); % 50 cycles at 2Hz
%   T = t_start:dt:t_end;
%   SC = vlt.neuroscience.spiketrains.spiketimes2bins(ST,T);
%   R = vlt.neuroscience.spiketrains.spiketrain2rate(SC,dt,0.005);
%   figure;
%   subplot(2,1,1);
%   plot(T,R);
%   hold on;
%   plot(T,vlt.math.rectify(rate_offset+maxrate*sin(2*pi*tFreq*T+phase)),'g');
%   xlabel('Time(s)'); ylabel('Rate (spikes/s)'); box off;
%   subplot(2,1,2);
%   plot(cumsum(R),cumsum(vlt.math.rectify(rate_offset+maxrate*sin(2*pi*tFreq*T+phase))),'bo');
%   hold on;
%   plot([0 sum(R)],[0 sum(R)],'k--');
%   xlabel('Cumulative rate measured (spikes)'); ylabel('Actual cumulative rate (spikes)'); 
%   axis equal square; box off;
%   

BlurFunc = 'gaussian';

vlt.data.assign(varargin{:});

switch BlurFunc,
	case 'gaussian',
		gaussian_tvec = -blur*5:dt:blur*5;
		myfilter = 1/(blur* sqrt(2*pi)) * exp(-0.5 * ((gaussian_tvec-0)/blur).^2);
		myfiler = myfilter/sum(myfilter);
	otherwise,
		error(['Unknown blur function ' BlurFunc '.']);
end;

rate = conv(spiketrain, myfilter, 'same');

