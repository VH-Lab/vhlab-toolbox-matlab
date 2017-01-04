function [mel, di, r_up, r_down, modelrun_up, modelrun_down] = directionselectivity4celldemo(varargin)
% DIRECTIONSELECTIVITY4CELLDEMO - Demo of a 4 input, single layer direction-selective output cell
%
%  [MODELEL, DI, R_UP, R_DOWN] = DIRECTIONSELECTIVITY4CELLDEMO
%
%  Enter "TYPE DIRECTIONSELECTIVITY4CELLDEMO" to see the code.
%  Input cells: 1-4
%  Cells 1 and 2 are at position 1, cells 3 and 4 are at position 2. Cells 1 and 3 fire instantly,
%  while cells 2 and 4 have a latency.
%
%  One can modify the default parameters by passing name/value pairs to the function like this
%  [MODELEL, DI, UP, DOWN] = DIRECTIONSELECTIVITY4CELLDEMO(PARAM1NAME, PARAM1VALUE, ...)
%
%  Default parameters are as follows:
%  ----------------------------------------------------------------------
%  dt (1e-4)                      |  Step size of model
%  latency (0.200)                |  Latency of between cell 1, 2 and 3, 4
%  lag (0.200)                    |  Lag of stimulus arrival between cell 1, cell3
%  Syn_Gmax_initial (1x4, 4e-9)   |  Initial synaptic weight (about 75% of threshold)
%  plasticity_params ([])         |  Synapse plasticity params 
%  plasticity_method ('')         |  Synapse plasticity method
%  isi (0.75)                     |  Inter-stimulus-interval (seconds)
%  plotit (1)                     |  0/1 should we plot the behavior in a new figure?
%  simit (1)                      |  0/1 Actually do simulation (1) or just build model(0)?
%  simup (1)                      |  0/1 Actually simulate upward direction (1)?
%  simdown (1)                    |  0/1 Actually simulate downward direction (1)?
%  intfireparams                  |  {'name1','value1'} parameter list to pass to intfireleakyel_init
%  synapseparams                  |  {'name1','value1'} parameter list to pass to synapset1t2el_init
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
%     [mel,di,rup,rdown]=directionselectivity4celldemo;
%
%     % a direction-selective model
%     [mel,di,rup,rdown]=directionselectivity4celldemo('Syn_Gmax_initial',[0 4 4 0]*1e-9);
%  
%  See also: INTFIRELEAKY_SYNAPSEDEMO
%  

dt = 1e-4;
nreps = 1;
isi = 0.75; % 0.75 seconds
latency = 0.200;  % latency of the second layer, 200ms
lag = latency; % time between stimulus arriving at cell1 and cell3
Syn_Gmax_initial = 4e-9 * ones(1,4);  % whatever it needs to be to be 0.75 * threshold
plasticity_params = [];
plasticity_method = '';
plotit = 1;
simit = 1;
simup = 1;
simdown  = 1;
intfireparams = {};
synapseparams = {};

assign(varargin{:});

di = NaN;
r_up = NaN;
r_down = NaN;

end_time = dt + (nreps)*isi;%  + lag + latency;
timesteps = length(0:dt:end_time);

 % spike trains
cell1u = dt + [0:isi:(nreps-1)*isi];
cell2u = cell1u + latency;
cell3u = cell1u + lag; 
cell4u = cell3u + latency; 

 % create a prototype synapse
protosyn = synapset1t2el_init('plasticity_params',plasticity_params,...
			'plasticity_method',plasticity_method,synapseparams{:});

mel(1) = spiketimelistel_init('name','cell1','spiketimes',cell1u);
mel(2) = spiketimelistel_init('name','cell2','spiketimes',cell2u);
mel(3) = spiketimelistel_init('name','cell3','spiketimes',cell3u);
mel(4) = spiketimelistel_init('name','cell4','spiketimes',cell4u);
mel(5) = intfireleakyel_init('name','output',intfireparams{:});

mel = modelelsynconn(mel,1:5,[nan(5,4) [Syn_Gmax_initial'; NaN] ], protosyn);

if ~simit,
	return;
end;

  % simulate up here, extract output
varstosave = { 'modelrunstruct.Model_Final_Structure(5).T',...
			'modelrunstruct.Model_Final_Structure(5).model.V' };

if simup,
	[modelrun_up,varsout_up] = modelelrun(mel,'Steps',timesteps,'Variables',varstosave);
	cell5u = modelrun_up.Model_Final_Structure(5).model.spiketimes;
	r_up = length(cell5u);
else,
	cell5u = [];
	r_up = NaN;
end;

  % now set up to simulate down 
cell3d = dt + [0:isi:(nreps-1)*isi];
cell4d = cell3d + latency;
cell1d = cell3d + lag; 
cell2d = cell1d + latency; 
mel(1).model.spiketimes = cell1d;
mel(2).model.spiketimes = cell2d;
mel(3).model.spiketimes = cell3d;
mel(4).model.spiketimes = cell4d;

  % simulate down here, extract output
if simdown,
	[modelrun_down,varsout_down] = modelelrun(mel,'Steps',timesteps,'Variables',varstosave);
	cell5d = modelrun_down.Model_Final_Structure(5).model.spiketimes;
	r_down = length(cell5d);
else,
	cell5d = [];
	r_down = NaN;
	varsout_down = varsout_up;
	varsout_down(2,:) = varsout_up(2,1);
end;

if simdown&~simup,
	varsout_up = varsout_down;
	varsout_up(2,:) = varsout_down(2,1);
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
	xlabel('Time(s)');
	ylabel('Voltage(V)');
	legend;
	a = axis;
	axis([varsout_up(1,1) varsout_down(1,end)+end_time -0.08 0.02]);
	box off;
	title('First 1s is up, second 1s is down');
	a = axis;
	
	

	subplot(2,1,2);
	ymin = [0 1 2 3 5]+0.1;
	ymax = [1 2 3 4 6]-0.1;
	for j=1:5,
		cellu = eval(['cell' int2str(j) 'u;']);
		celld = eval(['cell' int2str(j) 'd;']);
		num = length(cellu)+length(celld);
		if num>0,
			X = repmat([cellu end_time+celld],2,1);
			Y = repmat([ymin(j) ymax(j)]', 1, num);
			plot(X,Y,'k','linewidth',1.5,'color',cmyk2rgb(cmyk_color(j,:)));
			hold on;
		end;
	end;
	axis([a(1) a(2) -1 7]);
	box off;
	
	xlabel('Time(s)');
	title('Spike');
end;

