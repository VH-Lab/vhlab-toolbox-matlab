function [nMLEFit,nHSTD, gain, T] = slowdenoise(spiketimes, stimetimes, stimids, actualR, t0, t1, dt, tFilter, f)
% SLOWDENOISE - Remove slow gain changes from spike train
%   [RATE, GAIN, T] = SLOWDENOISE(SPIKETIMES, STIMTIMES, STIMIDS, T0, T1, DT, TFILTER, F)
%
%      STIMTIMES - An S x 2 matrix where S is the number of stims,
%               and the first column is the onset time for each stim, and 
%               the second column is the offset time for each stim
%      TFILTER - Time resolution of the filter (e.g., 0.1 seconds)  
%   

smoothness = 1;
sindx = tfilter;


  % Step 1: Perform slow filtering

ExpLength = t1 - t0;
longtimeaxis = 0:sindx:ExpLength; % units of seconds
Lspiketimes = 0*longtimeaxis;
spiketimes = spiketimes - t0; % start from t0

for qrq=1:length(spiketimes), % put spikes in low time resolution axis
	a = find(spiketimes(qrq)>longtimeaxis,1,'last');
	Lspiketimes(a) = Lspiketimes(a) + 1;
end;

 % filter
PillBox = ones(1,100*(1/sindx));  % so the filter will be 1000 pixels long...why?
PillBox = PillBox/sum(PillBox); % okay, we normalize it so it won't add any magnitude to the data
ConvedSpikes = conv(Lspiketimes,PillBox,'same')*(1/sindx);  % hmm, why multiply by 1/sindx

LT = 2*pi*(longtimeaxis'/longtimeaxis(end)); % slow sinwave over whole data

  % Fit a 4 component sin wave where frequency has to be less than 10

options = fitoptions('sin4');
options.Upper = [Inf 10 Inf Inf 10 Inf Inf 10 Inf Inf 10 Inf];
[FT O] = fit(LT,ConvedSpikes','sin4',options);
figure(22); plot(LT, ConvedSpikes,LT,FT(LT));
sinparams = [FT.a1 FT.b1 FT.c1 FT.a2 FT.b2 FT.c2 FT.a3 FT.b3 FT.c3 FT.a4 FT.b4 FT.c4];

  % Step 2: Estimate the "true" responses, with gain removed

stimonoff = reshape(stimtimes, 1, prod(size(stimtimes)));

timeaxis = stimonoff;

spiketimes2 = (0*timeaxis);
                    
for qrq = 1:length(spiketimes)
   a = find((spiketimes(qrq)) > timeaxis,1,'last');
   spiketimes2(a) = spiketimes2(a) + 1;                                           %%D = data for the model
end      

stimulitimes = (0*timeaxis);

for qrq = 1:size(stimtimes,1)
   %%First for the stim periods
   a = find((stimtimes(qrq,2)) > timeaxis,1,'last'); %
   stimulitimes(a) = stimids(qrq);                                               %%s(t) for the model
end

spiketimes = spiketimes';
stimulitimes = stimulitimes';

dt = diff(stimonoff');
dt(end+1) = dt(end-1);  % make sure the last stimulus has an ISI, use previous stim ISI

mF = mean(actualR);
x0 = [0; mF'];

fixA = sinparams(1:3:12)';

[x fval] = MLE_Pois(t,dt,spiketimes,stimulitimes,sinparams,fixA,1,x0,smoothness);

for zz = 1:10;
	x0 = fixA;
	fixF = x;
	if F==0,
		[x fval] = MLE_Pois(t,dt,spiketimes,stimulitimes,sinparams,fixF,0,x0,smoothness);
	else,
		[x fval] = MLE_Gauss(t,dt,F1Magnitude,stimulitimes,sinparams,fixF,0,x0,smoothness);
	end;
	mle(zz,1) = fval;

	x0 = fixF;
	fixA = x;
	if F==0,
		[x fval] = MLE_Pois(t,dt,spiketimes,stimulitimes,sinparams,fixA,1,x0,smoothness);
	else,
		[x fval] = MLE_Gauss(t,dt,F1Magnitude,stimulitimes,sinparams,fixA,1,x0,smoothness);
	end;
		mle(zz,2) = fval;
	end;
end

time = (2*pi)*(t/max(t));
SPs = sinparams;
g0 = fixA;

gfinal = g0(1)*(sin(SPs(2)*time + SPs(3))) + g0(2)*(sin(SPs(5)*time + SPs(6))) + g0(3)*(sin(SPs(8)*time + SPs(9))) + g0(4)*(sin(SPs(11)*time + SPs(12)));

 % Step 4: return time series

RawTimeseriesData{1} = [T'; ConvedSpikes; FT(LT)'];
RawTimeseriesData{2} = [t'; gfinal'];


 % Step 5: return most likely responses and standard deviation of most likely responses

%% Hessian diagonal:

for i = 1:length(x);
    H(i) = sum((spiketimes(stimulitimes == (i-1))./(-x(i).^2)));
end

Hstd = sqrt(-1./H);
Hstd(isinf(Hstd)) = 0;

%%

T = ExpLength*(LT/(2*pi));

MLEfit = x(2:max(stimnum));
HSTD = Hstd(2:max(stimnum));
nHSTD = Hstd(2:max(stimnum))./max(MLEfit_F0);
nMLEfit = MLEfit_F0./max(MLEfit_F0);

