function [s_i_current, g_current, sinparams,mle,responses_observed, stimlist, responses_s_i, smooth_time, smooth_spikerate, sinfit_smooth_spikerate] = SlowMLEDeNoise(stim_onsets, stim_offsets, stimvalues, spike_times, varargin)
% SlowMLEDeNoise -- Estimate underlying stimulus response assuming a slow background drift in gain
%
%   [RESPONSES, SIN_WEIGHTS] = vlt.neuroscience.mledenoise.SlowMLEDeNoise(STIM_ONSETS, STIMOFFSETS, STIMVALUES, ...
%	SPIKE_TIMES, [PARAM1, VALUE1, ...]);
%      
%        (see additional output arguments below)
%  
%   This function assumes that the response to a neural spike train in response to stimuli
%   s_i can be written as
%  
%   r(t) = g(t) * s_i(t) 
%
%   where r(t) is the actual response observed as a function of time, g(t) is an unknown
%   slow background gain modulation of the cortex, and s_i(t) is the unknown mean response
%   to each stimulus.
%
%   The parameters g(t) and s_i(t) are estimated using a maximum likelihood approach.
%
%   First, initial estimates of g(t) and s_i(t) are made.  The function g(t) is fit
%   as the sum of 4 sinusoids. These sinwaves are constrained to have very low
%   temporal frequencies, and cannot take a temporal frequency faster than 1/10
%   of the total trial duration by default (see 'maxFrequency' parameter below).
%   The measured mean response to each stimulus is taken to be the initial estimate of
%   s_i(t).
%   
%   We then iteratively re-estimate s_i(t) and g(t) to increase the likelihood of the 
%   data r(t) that we actually observed. First, s_i(t) is fixed while g(t) is re-estimated,
%   and then g(t) is fixed while s_i(t) is re-estimated.  This process is repeated 10 times
%   be default (see 'numIterations' parameter below).
%
%   Note: This is a generalization of code that Dan Rubin wrote as part of his PhD Thesis:  
%   "A Novel Circuit Model of Contextual Modulation and Normalization in Primary Visual Cortex"
%   Columbia University 2012
%
%   RESPONSES are the estimated mean responses to each unique stimulus.
%   SIN_WEIGHTS are the best-fit amplitude coefficients to the underlying 4 term sinusoidal fit.
%
%   PARAMETERS that can be modified, with default values:
%       'mlesmoothness'         :   Constraint of smoothness of second derivative of stimulus
%                               :      response. Default 0.1 response units squared/stimvalues squared.
%                               :      The 2nd derivative calculation assumess that STIMVALUES are
%                               :      equally spaced.  Any change that is faster than this constraint
%                               :      is not allowed.
%       'tFilter'               :   Timecourse of spikerate filter, default 100 (seconds)
%       'sin_dt'                :   Step size for smoothed sinusoid function, default 0.1 (seconds)
%       'dt'                    :   Step size for simulated firing rate, default 1/1000 (seconds)
%       'model'                 :   Can be 'Poisson' or 'Gaussian' (case insensitive)
%                               :      Use 'Poisson' for spike responses, and 'Gaussian' for 
%                               :      continuous-valued measurements (spike rates/voltages/etc)
%       'responses_s_i'         :   Responses to each stimulus; if this is
%                               :      empty, then the spike rates are calculated from the
%                               :      stimulus on and off times (average rate) (default [])
%                               :      If you want to calculate the response to a continuous
%                               :      process such as the F1 component or a voltage, then
%                               :      you must provide this.
%                               :      This quantity serves as the r(t) to be fit, and also
%                               :      serves as the initial estimate of s(t).
%       'prerecordtime'         :   Number of seconds before the first stimulus that we assume 
%                               :      the recording of spikes began (default 5)
%       'postrecordtime'        :   Number of seconds after the last stimulus that we assume 
%                               :      the recording of spikes continued (default 5)
%       'maxFrequency'          :   Maximum temporal frequency of the smoothed sinewave, where
%                               :      1 cycle is the duration of the whole experiment. Default 10
%       'numIterations'         :   Number of re-estimation steps to perform. Default 10.
%       'verbose'               :   0/1 Prints what is going on as function runs (default 0)
%
%   One can also retrieve additional outputs:
%
%   [RESPONSES, SIN_WEIGHT, FIT_SIN4, MLE, RESPONSE_OBSERVED,...
%       STIMLIST, RESPONSES_S_I, SMOOTH_TIME, SMOOTH_SPIKERATE, SINFIT_SMOOTH_SPIKERATE]...
%           = vlt.neuroscience.mledenoise.SlowMLEDeNoise(STIM_ONSETS, STIMOFFSETS, STIMVALUES, ...
%	          SPIKE_TIMES, [PARAM1, VALUE1, ...]);
%
%   FIT_SIN4 is a set of 13 coefficients to a 4th order sinusoidal fit (see vlt.fit.sin4_fit), 
%   MLE is the actual maximum likelihood value
%   RESPONSE_OBSERVED is the actual responses that were observed. In the case of the Poisson
%      model, this is the number of spikes per stimulus. In the case of the Gaussian model,
%      this is the response rate.
%   STIMLIST is the order in which the stimuli were presented; stimuli are numbered
%      according to the value of STIMVALUES, from least to greatest (see help UNIQUE)
%   RESPONSES_S_I are the responses (r(t)*g(t)) for each stimulus in STIMLIST
%   
%
%  Examples:  see vlt.neuroscience.mledenoise.testSlowMLE and vlt.neuroscience.mledenoise.testSlowMLE_modulation
%          ('type vlt.neuroscience.mledenoise.testSlowMLE'  and 'type vlt.neuroscience.mledenoise.testSlowMLE_modulation')
%  
%  See also:  FIT_SIN4

  % debugging mode, currently disabled
  %       'showfitting'           :   Show graphical progress of fitting in a new figure (default 0)
  %

   
sin_dt = 0.1;
mlesmoothness = 0.1;
model = 'Poisson';
responses_s_i = [];
tFilter = 100; % number of seconds to smooth over
prerecordtime = 5;
postrecordtime = 5;
maxFrequency = 10;  % in units of the length of the whole experiment
numIterations = 10;
dt = 1/1000;
showfitting = 0;
verbose = 0;

vlt.data.assign(varargin{:});

if isempty(responses_s_i) & strcmp(model,'Gaussian'),
	warning(['Under the Gaussian model, one usually wants to provide the responses to each stimulus responses_s_i.']);
end;

 % Step 1:  Create initial estimate of g(t) by computing a 4 sinwave fit of the firing rate
 %              smoothed with a box filter with window size tFilter

smooth_time = (min(stim_onsets)-prerecordtime):sin_dt:(max(stim_offsets)+postrecordtime);
smooth_spikecounts = vlt.neuroscience.spiketrains.spiketimes2bins(spike_times,smooth_time);
PillBox = ones(1,tFilter*(1/sin_dt));
PillBox = PillBox/sum(PillBox);
smooth_spikerate = conv(smooth_spikecounts,PillBox,'same')*(1/sin_dt); % smooth and divide by delta t to make it a rate
 % now fit a sinewave to the smoothed rate

if verbose,
	disp(['vlt.neuroscience.mledenoise.SlowMLEDeNoise: about to perform vlt.fit.sin4_fit']);
	verbfig = figure;
	plot(smooth_time,smooth_spikerate,'r','linewidth',2,'DisplayName','Smooth Spikerate');
	xlabel('Time(s)');
	hold on;
end;

[sinfit_smooth_spikerate,sinparams] = vlt.fit.sin4_fit(smooth_time,smooth_spikerate,maxFrequency,0);

if verbose, disp(['vlt.neuroscience.mledenoise.SlowMLEDeNoise: vlt.fit.sin4_fit done']); end;

if verbose, 
	figure(verbfig);
	plot(smooth_time,sinfit_smooth_spikerate,'g','linewidth',2,'DisplayName','Sinusoidal Fit Spikerate');
	xlabel('Time(s)');
	legend;
end;

 % Step 2:  Determine the actual measured responses r(t) for each stimulus

if isempty(responses_s_i),
	for i=1:length(stimvalues),
		responses_s_i(i)=length(find(spike_times>=stim_onsets(i)&spike_times<=stim_offsets(i))) ...
			/(stim_offsets(i)-stim_onsets(i));
	end;
end;

 % Step 3: Determine the average response for each type of stimulus

stimshere = unique(stimvalues);
stim_step = median(diff(stimshere));
s_i_initial = [];
stimlist = zeros(size(stimvalues)); % a list of stimids, sorted by stimvalues
for i=1:length(stimshere),
	inds = find(stimvalues==stimshere(i));
	s_i_initial(i) = nanmean(responses_s_i(inds));
	stimlist(inds) = i;
end;

 % Step 4:  Now create a model of r(t) = g(t) * s_i(t)
 %          We only need to estimate this at the specific values of t where there are stimuli
 
stim_center_times = mean([stim_onsets(:) stim_offsets(:)],2); % time of all stims
stim_durations = diff([stim_onsets(:) stim_offsets(:)]');      % duration of all stims

g_current = sinparams(1:3:end)';

find_s = 1;  % use this value when we want to find s
find_g = 0;  % use this value when we want to find g

%colors = get(gca,'ColorOrder');
%plotind = 0;

if strcmp(model,'Poisson'),
	spikecounts_observed = responses_s_i.* stim_durations; % convert to spike counts
	responses_observed = spikecounts_observed;
	% make sure we don't have any rounding, these need to be integers or factorial in likelihood will fail
	responses_observed = round(responses_observed);
else
	%error(['Gaussian model not functioning yet.']);
	responses_observed = responses_s_i;
end;

if verbose, disp(['vlt.neuroscience.mledenoise.SlowMLEDeNoise: about to fit']); end;


  % optionally, could include showfitting code at part 1 below
[s_i_current, fval] = vlt.neuroscience.mledenoise.MLE_PoisGauss(stim_center_times,stim_durations,responses_observed,...
	sinparams, stimlist, model,find_s, g_current,s_i_initial,mlesmoothness * stim_step * stim_step);
mle(1,1) = fval;
  % could include part 2 debugging code here
for zz = 1:numIterations,
	if verbose, disp(['vlt.neuroscience.mledenoise.SlowMLEDeNoise: beginning iteration ' num2str(zz) ]); end;
	[g_current,fval]=vlt.neuroscience.mledenoise.MLE_PoisGauss(stim_center_times,stim_durations,responses_observed,...
		sinparams,stimlist,model,find_g,g_current,s_i_current,mlesmoothness);
	mle(zz+1,1) = fval;
	[s_i_current,fval]=vlt.neuroscience.mledenoise.MLE_PoisGauss(stim_center_times,stim_durations,responses_observed,...
		sinparams,stimlist,model,find_s,g_current,s_i_current,mlesmoothness);
	mle(zz+1,2) = fval;
	% part 3 here, optionally
	%H = 1./(-s_i_current.^2);
	%s_i_stddev = sqrt(-1./H);
	%s_i_stddev(isinf(s_i_stddev)) = 0;
end;


return;

 % retired code


 % debugging show fitting code:
 % part 0
if 0,  % for testing purposes
	real_sinparams = [ 0.5 2*pi/300 0 0 0 0 0 0 0 0 0 0 ];
	sinparams = real_sinparams;
end;

if showfitting,
	fig = figure;
	plot(smooth_time(:),smooth_spikerate(:),'b');
	hold on
	plot(smooth_time(:),fit_values,'r');
end;

  %% part 1
		if showfitting,
			fig = figure;
			h1 = plot(stim_center_times, responses_s_i,'b');
			hold on;
			RR = vlt.neuroscience.mledenoise.response_gaindrift_model(stim_center_times,stim_durations,stimlist, sinparams,g_current,s_i_initial);
			h2 = plot(stim_center_times, RR,'color',colors(1+mod(plotind,size(colors,1)),:));
			plotind = plotind + 1;
			pause(1); drawnow;
			mle(1,3) = -vlt.neuroscience.spiketrains.loglikelihood_spiketrain(RR,stim_durations,spikecounts_observed);
		end;
  %% part 2
		if showfitting,
				RR = vlt.neuroscience.mledenoise.response_gaindrift_model(stim_center_times,stim_durations,stimlist,sinparams,g_current,s_i_current);
				h2 = plot(stim_center_times, RR,'color',colors(1+mod(plotind,size(colors,1)),:));
				plotind = plotind + 1;
				pause(1); drawnow;
				mle(1,2) = -vlt.neuroscience.spiketrains.loglikelihood_spiketrain(RR,stim_durations,spikecounts_observed);
		end;
			if showfitting,
				RR = vlt.neuroscience.mledenoise.response_gaindrift_model(stim_center_times,stim_durations,stimlist,sinparams,g_current,s_i_current);
				h2 = plot(stim_center_times, RR,'color',colors(1+mod(plotind,size(colors,1)),:));
				plotind = plotind + 1;
				pause(1); drawnow;
				mle(zz+1,3) = -vlt.neuroscience.spiketrains.loglikelihood_spiketrain(RR,stim_durations,spikecounts_observed);
			end;



%% Try to filter out noise operating on a sloooow timescale:




global mydatapath datadate dataDir ds StimVar mycell smoothness testnumber cellnum BrokeExperiment

clear para stimnum stimtime spikes F0 F1 x_variable CorrF0 CorrF1 pspara corc stimonoff Lspiketimes

tFilter = 100;  %ms

addstimnumbertoscriptfields([mydatapath datadate filesep dataDir]);                              

g = load([getpathname(ds) filesep dataDir filesep 'stims.mat']);
%%    
if g.MTI2{end}.startStopTimes(4) == 0

   for i = 1:length(g.MTI2)
       StopTimes(i) = g.MTI2{i}.startStopTimes(4);      
   end
   FirstStopTime = find(StopTimes == 0);
   FirstStopTime = FirstStopTime(1);    
   LastStim = FirstStopTime - 1;
   
   
   G.saveScript = g.saveScript;
   G.start = g.start;
   G.MTI2 = g.MTI2(1:LastStim);
   
   g = G;
end
  
%%

g.MTI2 = tpcorrectmti(g.MTI2,[getpathname(ds) filesep dataDir filesep 'stimtimes.txt'],1);
 
% spikes - spikes for each stimulus
% stimtime - the interval of time corresponding to each stimulus
% stimnumber - the stimid of each stimulus
% para - the parameters

% I can fill these out with my own code



for qq = 1:length(g.MTI2)
           
                para{qq} = getparameters(get(g.saveScript,g.MTI2{qq}.stimid));   %%Parameters for luminance gratings
                stimnum(qq) = para{qq}.stimnumber;
                stimtime{qq} = [g.MTI2{qq}.startStopTimes(2) g.MTI2{qq}.startStopTimes(3)] - g.start;
                spikes{qq} = get_data(mycell,[g.MTI2{qq}.startStopTimes(2) g.MTI2{qq}.startStopTimes(3)]);
                
                stimonoff(2*qq) = stimtime{qq}(1);
                stimonoff(2*qq + 1) = stimtime{qq}(2);
                
                F0(qq) = length(spikes{qq})/(g.MTI2{qq}.startStopTimes(3)-g.MTI2{qq}.startStopTimes(2));
                
                dx = 1/1000;
                StimLength = g.MTI2{qq}.startStopTimes(3) - g.MTI2{qq}.startStopTimes(2);
                timeaxis = 0:dx:StimLength;
                spiketimes = (0*timeaxis);
                stimspikes = spikes{qq};
                   
                for qr = 1:length(stimspikes)
                    a = find(stimspikes(qr) > timeaxis);
                    spiketimes(a(end)) = spiketimes(a(end)) + 1; 
                end
                
                if ~isfield(para{qq},'isblank')                    %%for blank parameter there is no F1
                    if isfield(para{qq},'ps_mask')
                        pspara{qq} = getparameters(para{qq}.ps_mask);
                        tF = pspara{qq}.tFrequency;
                        if length(StimVar) == 10
                            if sum(StimVar == 'stimnumber') == 10;
                                x_variable(qq) = eval(['para{qq}.' StimVar]);  
                            else
                            x_variable(qq) = eval(['pspara{qq}.' StimVar]);
                            end
                        else
                        x_variable(qq) = eval(['pspara{qq}.' StimVar]);
                        end
                    else
                        tF = para{qq}.tFrequency;
                        x_variable(qq) = eval(['para{qq}.' StimVar]);
                    end
                    
                    
                    F1(qq) = sum(spiketimes.*exp(-2*pi*sqrt(-1)*tF*timeaxis));
                    
                else
                    F1(qq) = 0;
                    x_variable(qq) = NaN;
                end
                
                 
                
end

%% Build MxN matrices of responses -- M repeats of N stimuli
% 
F0wSN = [F0' stimnum' x_variable'];
F1wSN = [F1' stimnum' x_variable'];

% matrixes

% -- here is meat


if length(F0wSN)/max(stimnum) < ceil(length(F0wSN)/max(stimnum))
    F0wSN = [F0wSN; zeros(ceil(length(F0wSN)/max(stimnum))*max(stimnum) - length(F0wSN),3)];
    F1wSN = [F1wSN; zeros(ceil(length(F1wSN)/max(stimnum))*max(stimnum) - length(F1wSN),3)];
end
    
F0wSN = sortrows(F0wSN,2);
F1wSN = sortrows(F1wSN,2);

nReps = length(F0wSN)/max(stimnum);

F0mat = reshape(F0wSN(:,1),(nReps),max(stimnum));         
F1mat = reshape(F1wSN(:,1),(nReps),max(stimnum));

meanF0 = mean(F0mat);
meanF1 = mean(F1mat);

xparams = F0wSN(1:nReps:end,3);
%% First Get Spike Train

allspikes = get_data(mycell,[g.start g.MTI2{end}.startStopTimes(4)],2);

allspikes = allspikes - g.start;

if length(allspikes > 0)

%% Smooth spike train and extract sine wave basis functions:

ExpLength = g.MTI2{end}.startStopTimes(4) - g.start;

sindx = 0.1;

longtimeaxis = 0:sindx:ExpLength;

Lspiketimes = (0*longtimeaxis);
                    
for qrq = 1:length(allspikes)
   a = find(allspikes(qrq) > longtimeaxis,1,'last');
   Lspiketimes(a) = Lspiketimes(a) + 1; 
end  

PillBox = ones(1,tFilter*(1/sindx));
PillBox = PillBox/sum(PillBox);
             
ConvedSpikes = conv(Lspiketimes,PillBox,'same')*(1/sindx);

%ConvedSpikes = ConvedSpikes./mean(ConvedSpikes);

LT = 2*pi*(longtimeaxis'/longtimeaxis(end));

options = fitoptions('sin4');

options.Upper = [Inf 10 Inf Inf 10 Inf Inf 10 Inf Inf 10 Inf];

[FT O] = fit(LT,ConvedSpikes','sin4',options);

figure(22); plot(LT,ConvedSpikes,LT,FT(LT));

sinparams = [FT.a1 FT.b1 FT.c1 FT.a2 FT.b2 FT.c2 FT.a3 FT.b3 FT.c3 FT.a4 FT.b4 FT.c4];

%sinparams = 1;

%% Build the pieces for MLE

ExpLength = g.MTI2{end}.startStopTimes(4) - g.start;

timeaxis = stimonoff;
t = timeaxis';

spiketimes = (0*timeaxis);
                    
for qrq = 1:length(allspikes)
   a = find((allspikes(qrq)) > timeaxis,1,'last');
   spiketimes(a) = spiketimes(a) + 1;                                           %%D = data for the model
end      

stimulitimes = (0*timeaxis);

for qrq = 1:length(stimnum)
   %%First for the stim periods
   a = find((stimtime{qrq}(2)) > timeaxis,1,'last');
   stimulitimes(a) = stimnum(qrq);                                               %%s(t) for the model
end

spiketimes = spiketimes';
stimulitimes = stimulitimes';

dt = diff(stimonoff');
dt(end+1) = dt(end-1);

%%
clear mle

mF0 = mean(F0mat);
x0 = [0; mF0'];

fixA = sinparams(1:3:12)';

[x fval] = vlt.neuroscience.mledenoise.archived_code.MLE_Pois(t,dt,spiketimes,stimulitimes,sinparams,fixA,1,x0,smoothness);

for zz = 1:10;
        
    x0 = fixA;

    fixF = x;
    
    [x fval] = vlt.neuroscience.mledenoise.archived_code.MLE_Pois(t,dt,spiketimes,stimulitimes,sinparams,fixF,0,x0,smoothness);

    mle(zz,1) = fval;

    x0 = fixF;

    fixA = x;
    
    [x fval] = vlt.neuroscience.mledenoise.archived_code.MLE_Pois(t,dt,spiketimes,stimulitimes,sinparams,fixA,1,x0,smoothness);

    mle(zz,2) = fval;

zz
end

time = (2*pi)*(t/max(t));
SPs = sinparams;
g0 = fixA;

gfinal = g0(1)*(sin(SPs(2)*time + SPs(3))) + g0(2)*(sin(SPs(5)*time + SPs(6))) + g0(3)*(sin(SPs(8)*time + SPs(9))) + g0(4)*(sin(SPs(11)*time + SPs(12)));

% x0 = fixF;
% [x fval H] = MLE_fix2(t,dt,spiketimes,stimulitimes,sinparams,fixA,1,x0,1);

%% Hessian diagonal:

clear H

for i = 1:length(x);

    %H1(i) = sum((spiketimes(stimulitimes == (i-1))./(gfinal(stimulitimes == (i-1)).*dt(stimulitimes == (i-1))))./(-x(i)^2));
    H(i) = sum((spiketimes(stimulitimes == (i-1))./(-x(i).^2)));
    
end

Hstd = sqrt(-1./H);
Hstd(isinf(Hstd)) = 0;

%%

T = ExpLength*(LT/(2*pi));

actualdata = mean(F0mat);
actualdata(:,end) = [];
STDactualdata = std(F0mat);
STDactualdata(:,end) = [];
nSTDactualdata = STDactualdata./max(actualdata);
nactualdata = actualdata./max(actualdata);

MLEfit_F0 = x(2:max(stimnum));
HSTD_F0 = Hstd(2:max(stimnum));
nHSTD_F0 = Hstd(2:max(stimnum))./max(MLEfit_F0);
nMLEfit_F0 = MLEfit_F0./max(MLEfit_F0);

%%

figure(192); 
clf
set(192,'position',[50 450 1000 450])
set(gca,'FontSize',16)
plot(T,ConvedSpikes,T,FT(LT),t,gfinal,'LineWidth',2)
xlim([0 T(end)])
ylabel('Firing Rate')
xlabel('Time (seconds)')
legend('Raw Data','g_{0}','g_{final}','location','best')
set(gca,'LineWidth',2)
box off

a = clock;

figtitle1 = sprintf('MLERaw%03.2f.eps',a(6));
figtitle2 = sprintf('MLERawS%03.2f.eps',a(6));

%saveas(192,figtitle1,'epsc')

figure(193); 
clf
set(gca,'FontSize',16)
plot(T,ConvedSpikes,T,FT(LT),t,gfinal,'LineWidth',1)
xlim([0 T(end)])
ylabel('Firing Rate')
xlabel('Time (seconds)')
legend('Raw Data','g_{0}','g_{final}','location','best')
set(gca,'LineWidth',2)
box off

%saveas(193,figtitle2,'epsc')

%%

RawTimeseriesData{1} = [T'; ConvedSpikes; FT(LT)'];
RawTimeseriesData{2} = [t'; gfinal'];
%figure; plot(1:30,actualdata,1:30,MLEfit)

%figure; plot(actualdata,MLEfit,'o')

stims = unique(x_variable);
stims(isnan(stims)) = [];

% figure(14)
% clf
% hold on
% errorbar(stims-0.1,actualdata,STDactualdata,'bo-','LineWidth',2)
% errorbar(stims+0.1,MLEfit,HSTD,'go-','LineWidth',2)
% legend('Raw Data','MLE')

figure(15)
clf
hold on
errorbar(stims,nactualdata,nSTDactualdata,'bo-','LineWidth',2)
errorbar(stims,nMLEfit_F0,nHSTD_F0,'go-','LineWidth',2)
xlabel(StimVar)
legend('Raw Data','MLE')

% and meat ends here	  
	  
	  
%% And now repeat for the F1 component, using a Gaussian rather than Poisson MLE model

timeaxis = stimonoff;
t = timeaxis';

F1Magnitude = (0*timeaxis);
                    
for qrq = 1:length(stimnum)
   a = find((stimtime{qrq}(2)) > timeaxis,1,'last');
   F1Magnitude(a) = abs(F1(qrq));                                                     %%D = data for the model
end      

stimulitimes = (0*timeaxis);

for qrq = 1:length(stimnum)
   a = find((stimtime{qrq}(2)) > timeaxis,1,'last');
   stimulitimes(a) = stimnum(qrq);                                               %%s(t) for the model
end

F1Magnitude = F1Magnitude';
stimulitimes = stimulitimes';

dt = diff(stimonoff');
dt(end+1) = dt(end-1);

%%
clear mle

mF1 = abs(mean(F1mat));
x0 = [0; mF1'];

fixA = sinparams(1:3:12)';

[x fval] = vlt.neuroscience.mledenoise.archived_code.MLE_Gauss(t,dt,F1Magnitude,stimulitimes,sinparams,fixA,1,x0,smoothness);

for zz = 1:10;
        
    x0 = fixA;

    fixF = x;
    
    [x fval] = vlt.neuroscience.mledenoise.archived_code.MLE_Gauss(t,dt,F1Magnitude,stimulitimes,sinparams,fixF,0,x0,smoothness);

    mle(zz,1) = fval;

    x0 = fixF;

    fixA = x;
    
    [x fval] = vlt.neuroscience.mledenoise.archived_code.MLE_Gauss(t,dt,F1Magnitude,stimulitimes,sinparams,fixA,1,x0,smoothness);

    mle(zz,2) = fval;

zz
end

time = (2*pi)*(t/max(t));
SPs = sinparams;
g0 = fixA;

gfinal = g0(1)*(sin(SPs(2)*time + SPs(3))) + g0(2)*(sin(SPs(5)*time + SPs(6))) + g0(3)*(sin(SPs(8)*time + SPs(9))) + g0(4)*(sin(SPs(11)*time + SPs(12)));

% x0 = fixF;
% [x fval H] = MLE_fix2(t,dt,spiketimes,stimulitimes,sinparams,fixA,1,x0,1);

%% Hessian diagonal:

clear H

for i = 1:length(x);

    %H1(i) = sum((spiketimes(stimulitimes == (i-1))./(gfinal(stimulitimes == (i-1)).*dt(stimulitimes == (i-1))))./(-x(i)^2));
    %H(i) = (sum((F1Magnitude(stimulitimes == (i-1))./(-x(i).^2))));
    H(i) = (sum(-(gfinal(stimulitimes == (i-1)).*dt(stimulitimes == (i-1))./(3)).^2));
end

Hstd = sqrt(-1./H);
Hstd(isinf(Hstd)) = 0;

%%

T = ExpLength*(LT/(2*pi));

actualdata = abs(mean(F1mat));
actualdata(:,end) = [];
STDactualdata = abs(std(F1mat));
STDactualdata(:,end) = [];
nSTDactualdata = STDactualdata./max(actualdata);
nactualdata = actualdata./max(actualdata);

MLEfit_F1 = x(2:max(stimnum));
HSTD_F1 = Hstd(2:max(stimnum));
nHSTD_F1 = Hstd(2:max(stimnum))./max(MLEfit_F1);
nMLEfit_F1 = MLEfit_F1./max(MLEfit_F1);

figure(1179); plot(T,ConvedSpikes,T,FT(LT),t,gfinal);
%figure; plot(1:30,actualdata,1:30,MLEfit)

%figure; plot(actualdata,MLEfit,'o')

stims = 1:(max(stimnum)-1);
stims = unique(x_variable);
stims(isnan(stims)) = [];
% figure(14)
% clf
% hold on
% errorbar(stims-0.1,actualdata,STDactualdata,'bo-','LineWidth',2)
% errorbar(stims+0.1,MLEfit,HSTD,'go-','LineWidth',2)
% legend('Raw Data','MLE')

figure(19)
clf
hold on
errorbar(stims,nactualdata,nSTDactualdata,'bo-','LineWidth',2)
errorbar(stims,nMLEfit_F1,nHSTD_F1,'go-','LineWidth',2)
xlabel(StimVar)
legend('Raw Data','MLE')


%%

mleF0Mat = [MLEfit_F0 HSTD_F0' nMLEfit_F0 nHSTD_F0']';
mleF1Mat = [MLEfit_F1 HSTD_F1' nMLEfit_F1 nHSTD_F1']';

MLEco.f0vals{1} = mleF0Mat;
MLEco.f1vals{1} = mleF1Mat;
MLEco.TimeSeries = RawTimeseriesData;  

else
    
MLEco.f0vals{1} = 0;
MLEco.f1vals{1} = 0;
MLEco.TimeSeries = 0;  
BrokeExperiment = BrokeExperiment+1;

end
