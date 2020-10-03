function [mel, di, r_up, r_down, modelrun_up, modelrun_down, inhib_r_up, inhib_r_down] = directionelectivityNcelldemo_inhib(varargin)
% DIRECTIONSELECTIVITY4CELLDEMO_INHIB - Demo of a 4 input, single layer direction-selective output cell with FF inhibition
%
%  [MODELEL, DI, R_UP, R_DOWN] = DIRECTIONSELECTIVITYNCELLDEMO_INHIB
%
%  Enter "TYPE DIRECTIONSELECTIVITYNCELLDEMO_INHIB" to see the code.
%
%  One can modify the default parameters by passing name/value pairs to the function like this
%
%  Default parameters are as follows:
%  ----------------------------------------------------------------------
%  dt (1e-4)                      |  Step size of model
%  latency (0.200)                |  Latency of between rows
%  lag (0.200)                    |  Lag of stimulus arrival at different positions
%  N (2)                          |  Number of different positions
%  R (2)                          |  Number of different latencies
%  randomness (0)                 |  Coefficient of gaussian random noise that is added to lag, latency
%                                 |    Note that the random value, once chosen, is used consistently each time
%                                 |    a visual stimulus is presented.
%  Syn_Gmax_initial (1xN*R, 4e-9) |  Initial synaptic weight (about 75% of threshold)
%  Syn_Gmax_initial_inhib (1xN*R, |  Initial synaptic weight of LGN to I connections (about 75% of threshold)
%                 4e-9)           |  
%  plasticity_params ([])         |  Synapse plasticity params for LGN to E ctx connections
%  plasticity_method ('')         |  Synapse plasticity method for LGN to E ctx connections
%  plasticity_params_inhib ([])   |  Synapse plasticity params for I to E connection
%  plasticity_method_inhib ('')   |  Synapse plasticity method for I to E connection
%  plasticity_params_ffinhib ([]) |  Synapse plasticity params for feedforward LGN to I connection
%  plasticity_method_ffinhib ('') |  Synapse plasticity method for feedforward LGN to I connection
%  isi (0.75)                     |  Inter-stimulus-interval (seconds)
%  plotit (1)                     |  0/1 should we plot the behavior in a new figure?
%  simit (1)                      |  0/1 Actually do simulation (1) or just build model(0)?
%  simup (1)                      |  0/1 Actually simulate upward direction (1)?
%  simdown (1)                    |  0/1 Actually simulate downward direction (1)?
%  intfireparams                  |  {'name1','value1'} parameter list to pass to intfireleakyel_init
%  intfireparams_inhib            |  {'name1','value1'} parameter list to pass to intfireleakyel_init
%  synapseparams                  |  {'name1','value1'} parameter list to pass to synapset1t2el_init
%  synapseparams_ffI              |  {'name1','value1'} parameter list to pass to synapset1t2el_init for feedforward connections to I cell
%  synapseparams_inhib            |  {'name1','value1'} parameter list of values to pass to inhibitory synapse
%                                 |    default value {'V_rev',-0.080}
%  ISyn_Gmax_initial              |  5.8e-9
%  slow (0)                       |  Show stimulus at half speed?
%  mask (1)                       |  Mask out any input cells?
%
%
%  Outputs:
%  MODELEL is the model produced by the function.  
%  DI is (R_UP-R_DOWN) / (R_UP+R_DOWN), note this is -1 to 1
%  R_UP is response to upward direction
%  R_DOWN is response to downward direction
%
%  Examples:
%     % a totally non-direction-selective model
%     [mel,di,rup,rdown]=directionselectivityNcelldemo_inhib;
%
%     % a direction-selective model
%     [mel,di,rup,rdown]=directionselectivityNcelldemo_inhib('Syn_Gmax_initial',[0 5 5 0]*1e-9);
%
%     % a 3 by 3 cell model
%     [mod,di,r_up,r_down] = directionselectivityNcelldemo_inhib('N',3,'R',3,'isi',1);
%
%     % a 10 position by 3 latency cell model:
%     [mod,di,r_up,r_down] = directionselectivityNcelldemo_inhib('N',10,'R',3,'isi',3);
%
%  See also: INTFIRELEAKY_SYNAPSEDEMO
%  

dt = 1e-4;
nreps = 1;
isi = 0.75; % 0.75 seconds
latency = 0.200;  % latency of the second layer, 200ms
lag = latency; % time between stimulus arriving at cell1 and cell3
N = 2;
R = 2;
Syn_Gmax_initial = NaN;
Syn_Gmax_initial_inhib = NaN;
plasticity_params = [];
plasticity_method = '';
plasticity_params_inhib = [];
plasticity_method_inhib = '';
plasticity_params_ffinhib = [];
plasticity_method_ffinhib = '';
randomness = 0;
plotit = 1;
simit = 1;
simup = 1;
simdown  = 1;
intfireparams = {};
intfireparams_inhib = {};
synapseparams = {};
synapseparams_ffI = {};
synapseparams_inhib = {'V_rev',-0.080};
ISyn_Gmax_initial = 5.8e-9;
slow = 0;
mask = 1;

assign(varargin{:});

if isnan(Syn_Gmax_initial), % make sure dimensions are right
	Syn_Gmax_initial = 4e-9 * ones(1,N*R);  % whatever it needs to be to be 0.75 * threshold
	warning('overriding Syn_Gmax_initial');
end;
if isnan(Syn_Gmax_initial_inhib), % make sure dimensions are right
	Syn_Gmax_initial_inhib = 4e-9 * ones(1,N*R);
	warning('overriding Syn_Gmax_initial_inhib');
end;

di = NaN;
r_up = NaN;
r_down = NaN;

inhib_r_up = NaN;
inhib_r_down = NaN;

end_time = dt + (nreps)*isi;%  + lag + latency;
timesteps = length(0:dt:end_time);

mel = spiketimelistel_init('name','dummy','spiketimes',[],'dT',dt);
mel = mel([]); % create an empty list

spiketrains_up = {};
inhib_spiketrains_up = {};
random_value = [];

 % spike trains, let's make them in column order
for n=1:N,
	for r=1:R,
		random_value(end+1) = randomness*randn;
		firstspike = dt + (r-1)*latency + (n-1)*(slow+1)*lag + random_value(end);
		if numel(mask)>1, 
			if mask(n,r)==0, firstspike = []; end;
		end;
		spiketrain = firstspike + [0:isi:(nreps-1)*isi];
		spiketrains_up{end+1} = spiketrain; % log it for plotting
		name = ['cell_' int2str(n) '_' int2str(r) ];
		mel(end+1) = spiketimelistel_init('name',name,'spiketimes',spiketrain,'dT',dt);
	end;
end;

 % create a prototype synapse
protosyn = synapset1t2el_init('plasticity_params',plasticity_params,...
			'plasticity_method',plasticity_method,synapseparams{:},'dT',dt);
protosynffI = synapset1t2el_init('plasticity_params',plasticity_params_ffinhib,...
			'plasticity_method',plasticity_method_ffinhib,synapseparams_ffI{:},'dT',dt);
 % there's no feed-forward inhib modification possible right now

protosyn_inhib = synapset1t2el_init('plasticity_params',plasticity_params_inhib,...
			'plasticity_method',plasticity_method_inhib,synapseparams_inhib{:},'dT',dt);

mel(end+1) = intfireleakyel_init('name','output',intfireparams{:},'dT',dt);
output_cell = length(mel);
mel(end+1) = intfireleakyel_init('name','inhib',intfireparams_inhib{:},'dT',dt);
inhib_cell = length(mel);

mel = modelelsynconn(mel,1:((N*R)+1),[nan(N*R+1,N*R) [Syn_Gmax_initial'; NaN] ], protosyn);
mel = modelelsynconn(mel,[1:((N*R)) N*R+2],[nan(N*R+1,N*R) [Syn_Gmax_initial_inhib'; NaN] ], protosynffI);
mel = modelelsynconn(mel,[N*R+1 N*R+2],[NaN NaN; ISyn_Gmax_initial NaN],protosyn_inhib);

if ~simit,
	return;
end;

  % simulate up here, extract output
varstosave = { ['modelrunstruct.Model_Final_Structure(' int2str(output_cell) ').T'],...
			['modelrunstruct.Model_Final_Structure(' int2str(output_cell) ').model.V'] ,...
			['modelrunstruct.Model_Final_Structure(' int2str(inhib_cell) ').model.V'] };
if simup,
	[modelrun_up,varsout_up] = modelelrun(mel,'Steps',timesteps,'Variables',varstosave);
	spiketrains_up{end+1} = modelrun_up.Model_Final_Structure(output_cell).model.spiketimes;
	r_up = length(spiketrains_up{end});
	inhib_spiketrains_up{end+1} = modelrun_up.Model_Final_Structure(inhib_cell).model.spiketimes;
	inhib_r_up = length(inhib_spiketrains_up{end});
else,
	spiketrains_up{end+1} = [];
	inhib_spiketrains_up{end+1} = [];
	r_up = NaN;
	inhib_r_up = NaN;
	modelrun_up = [];
end;

  % now set up to simulate down 

spiketrains_down = {};
inhib_spiketrains_down = {};

ind = 0;
 % spike trains, let's make them in column order
for n=1:N,
	for r=1:R,
		ind = ind + 1;
		firstspike = dt + (r-1)*latency + ((N-1)-(n-1))*(slow+1)*lag + random_value(ind);
		if numel(mask)>1,
			if mask(n,r)==0,
				firstspike = [];
			end;
		end;
		spiketrain = firstspike + [0:isi:(nreps-1)*isi];
		spiketrains_down{end+1} = spiketrain; % log it for plotting
		mel(ind).model.spiketimes = spiketrain;
	end;
end;

  % simulate down here, extract output
if simdown,
	[modelrun_down,varsout_down] = modelelrun(mel,'Steps',timesteps,'Variables',varstosave);
	spiketrains_down{end+1} = modelrun_down.Model_Final_Structure(output_cell).model.spiketimes;
	r_down = length(spiketrains_down{end});
	inhib_spiketrains_down{end+1} = modelrun_down.Model_Final_Structure(inhib_cell).model.spiketimes;
	inhib_r_down = length(inhib_spiketrains_down{end});
else,
	spiketrains_down{end+1} = [];
	r_down = NaN;
	inhib_spiketrains_down{end+1} = [];
	inhib_r_down = NaN;
	modelrun_down = [];
	varsout_down = varsout_up;
	varsout_down(2,:) = varsout_up(2,1); % set output to V_initial
	varsout_down(3,:) = varsout_up(3,1); % set output to V_initial
end;

if simdown&~simup,
	varsout_up = varsout_down;
	varsout_up(2,:) = varsout_down(2,1); % set output to V_initial
	varsout_up(3,:) = varsout_down(3,1); % set output to V_initial
end;

di = (r_up - r_down) / (r_up + r_down);

if plotit,

	cmyk_color =  ...
		[ [50    50   100 0]/100; ...
                [55.69 50   0   0]/100; ...
                [50    0    100 0]/100; ...
                [55.69 0    0   0]/100; ...
		[0 1 1 0]];

	figure;

	% first plot the voltages
	subplot(2,1,1);
	plot(varsout_up(1,:),varsout_up(2,:),'r','DisplayName','Up');
	hold on;
	plot(varsout_down(1,:)+end_time,varsout_down(2,:),'r','DisplayName','Down');
	plot(varsout_up(1,:),varsout_up(3,:)-0.1,'b','DisplayName','Up');
	plot(varsout_down(1,:)+end_time,varsout_down(3,:)-0.1,'b','DisplayName','Down');
	xlabel('Time(s)');
	ylabel('Voltage(V)');
	legend;
	a = axis;
	axis([varsout_up(1,1) varsout_down(1,end)+end_time -0.08 0.02]);
	box off;
	title('First is up, second is down');
	a = axis;
	
	subplot(2,1,2);

	for n=1:N,
	        for r=1:R,
			j = n+(r-1)*N;
			cellu = spiketrains_up{n+(r-1)*N};
			celld = spiketrains_down{n+(r-1)*N};
			num = length(cellu)+length(celld);
			if num>0,
				X = repmat([cellu end_time+celld],2,1);
				Y = repmat([j-1+0.1 j-0.1]', 1, num);
				plot(X,Y,'k','linewidth',1.5,'color',cmyk2rgb(cmyk_color(1+mod(j,size(cmyk_color,1)),:)));
				hold on;
			end;
		end;
        end;

	% now plot output cell
	j = j + 1;
	cellu = spiketrains_up{N*R+1};
	celld = spiketrains_down{N*R+1};
	num = length(cellu)+length(celld);
	if num>0,
		X = repmat([cellu end_time+celld],2,1);
		Y = repmat([j-1+0.1 j-0.1]', 1, num);
		plot(X,Y,'k','linewidth',1.5,'color',cmyk2rgb(cmyk_color(5,:))); 
	end;

        axis([a(1) a(2) -1 R*N+2]);
	box off;

	xlabel('Time(s)');
	title('Spike');
end;

