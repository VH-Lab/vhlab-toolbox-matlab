  % developed by Steve Van Hooser and Ishaan Khurana, with code from 
  % _An Introductory Course in Computational Neuroscience_ by Paul Miller


classdef vlt.neuroscience.models.hh.HHsynclass < vlt.neuroscience.models.hh.neuronmodelclass
    
	properties
		E_Na; % reversal for sodium channels (V)
		V_threshold; % threshold for spike detection for counting spike times
		spiketimes;
		spikesamples;
		E_K;   % reversal for potassium channels (V)
		G_L;   % leak conductance (S)
		G_Na;  % sodium conductance (S)
		G_K;   % potassium conductance (S)
		Na_Inactivation_Enable;
		TTX;
		TEA;
		SR; % is strontium on?
		AMPA; % is AMPA present?
		NMDA; % is NMDA present?
		GABA; % is GABA present?
		E_ESyn; % reversal for excitatory synapses
		E_ISyn; % reversal for inhibitory synapses
		GLUT_PNQ; % vector P, N, Q for glutamate
		ESyn1_times;
		ESyn2_times;
		ISyn_times;
		GABA_PNQ; % vector P, N, Q for GABA
		facilitation; % synapse facilitation
		facilitation_tau; % tau of synapse recovery
		V_recovery_time; % vesicle recovery time

		Total_AMPA_G; % total AMPA conductance as a function of time 
		Total_NMDA_G; % total NMDA conductance as a function of time
		Total_GABA_G; % total GABA conductance as a function of time
		
	end
    
	methods
		function HHobj = vlt.neuroscience.models.hh.HHsynclass(varargin)
			V_threshold = -0.015;
			E_Na = 0.045;
			E_K = -0.082; 
			G_L = 30e-9;
			G_Na = 12e-6;
			G_K = 3.6e-6;
			Na_Inactivation_Enable = 1;
			dt = 1e-5;
			TTX = 0;
			TEA = 0;


			% synapse stuff
			AMPA = 0;
			GABA = 0;
			NMDA = 0;
			SR = 0;
			
			E_ESyn = 0;
			E_ISyn = -0.090;
			GLUT_PNQ = [ 0.5 20 1e-6];
			GABA_PNQ = [ 0.5 20 1e-6];
			
			facilitation = 0;
			facilitation_tau = 0.150;
			V_recovery_time = 0.100;
			
			vlt.data.assign(varargin{:});

			HHobj = HHobj@vlt.neuroscience.models.hh.neuronmodelclass(varargin{:});
			HHobj.V_threshold = V_threshold; 
			HHobj.dt = dt;
			HHobj.t = HHobj.t_start:HHobj.dt:HHobj.t_end;
			HHobj.spiketimes = []; % must be initialized to empty
			HHobj.spikesamples = []; % must be initialized to empty
			HHobj.S = zeros(4,numel(HHobj.t));
			HHobj.S(1,1) = HHobj.V_initial; %voltage
			HHobj.S(2,1)=0.05; % m initial value , initialize sodium activation
			HHobj.S(3,1)=0.6; %h, % initalize sodium inactivation
			HHobj.S(4,1)=0.31; %n, % initialize potassium activation
			HHobj.E_Na = E_Na;
			HHobj.E_K = E_K; 
			HHobj.G_L = G_L;        
			HHobj.G_Na = G_Na;   
			HHobj.G_K = G_K;
			HHobj.Na_Inactivation_Enable = Na_Inactivation_Enable;
			HHobj.TTX = TTX;
			HHobj.TEA = TEA;

			HHobj.AMPA = AMPA;
			HHobj.NMDA = NMDA;
			HHobj.GABA = GABA;
			HHobj.SR = SR;

			HHobj.E_ESyn = E_ESyn;
			HHobj.E_ISyn = E_ISyn;
			HHobj.GLUT_PNQ = GLUT_PNQ;
			HHobj.GABA_PNQ = GABA_PNQ;
			HHobj.facilitation = facilitation;
			HHobj.facilitation_tau = facilitation_tau;
			HHobj.V_recovery_time = V_recovery_time;		

		end
        
		function [dsdt, Itot] = dsdt(HHobj,S_value)
			i = HHobj.samplenumber_current;
			Vm=S_value(1,1);
           		m=S_value(2,1);
			h=S_value(3,1);
			n=S_value(4,1);
			if ( Vm == -0.045 )     % to avoid dividing zero by zero
				alpha_m = 1e3;      % value calculated analytically
			else
				alpha_m = (1e5*(-Vm-0.045))/(exp(100*(-Vm-0.045))-1);
			end
			beta_m = 4000*exp((-Vm-0.070)/0.018);   % Sodium deactivation rate
			alpha_h = 70*exp(50*(-Vm-0.070));       % Sodium inactivation rate
			beta_h = 1000/(1+exp(100*(-Vm-0.040))); % Sodium deinactivation rate

			if ( Vm == -0.060)      % to avoid dividing by zero
				alpha_n = 100;      % value calculated analytically
			else                  % potassium activation rate
				alpha_n = (1e4*(-Vm-0.060))/(exp(100*(-Vm-0.060))-1);
			end
			beta_n = 125*exp((-Vm-0.070)/0.08);     % potassium deactivation rate
            
			tau_m = 1/(alpha_m+beta_m);
			m_inf = alpha_m/(alpha_m+beta_m);
        
			tau_h = 1/(alpha_h+beta_h);
			h_inf = alpha_h/(alpha_h+beta_h);
        
			tau_n = 1/(alpha_n+beta_n);
			n_inf = alpha_n/(alpha_n+beta_n);
            
			dmdt= (m_inf-m)/tau_m;
			dndt= (n_inf-n)/tau_n;
			dhdt= (h_inf-h)/tau_h;

			if HHobj.AMPA,
				I_AMPA = HHobj.Total_AMPA_G(i)*(HHobj.E_ESyn - Vm);
			else,
				I_AMPA = 0;
			end;
			if HHobj.NMDA,
				I_NMDA = vlt.neuroscience.models.synapses.nmda_voltage_gate(Vm)*HHobj.Total_NMDA_G(i)*(HHobj.E_ESyn - Vm);
			else,
				I_NMDA = 0;
			end;

			if HHobj.GABA,
				I_GABA = HHobj.Total_GABA_G(i)*(HHobj.E_ISyn - Vm);
			else,
				I_GABA = 0;
			end;

			if HHobj.TTX,
				I_Na = 0;
			elseif ~HHobj.Na_Inactivation_Enable,
				I_Na = HHobj.G_Na*m*m*m*(HHobj.E_Na-Vm); % total sodium current, no inactivation
			else, % regular case
				I_Na = HHobj.G_Na*m*m*m*h*(HHobj.E_Na-Vm); % total sodium current        
			end;
			if HHobj.TEA,
				I_K = 0;
			else,
				I_K = HHobj.G_K*n*n*n*n*(HHobj.E_K-Vm); % total potassium current
			end;
			I_L = HHobj.G_L*(HHobj.E_leak-Vm);    % Leak current is straightforward        
			if ~HHobj.involtageclamp,
					% total current is sum of leak + active channels + applied current
				Itot = I_AMPA+I_NMDA+I_GABA+I_L+I_Na+I_K+HHobj.I(i); 
			else,
				Itot = I_AMPA+I_NMDA+I_GABA+I_L+I_Na+I_K;
			end;
			dvdt=Itot/HHobj.Cm;
			dsdt = [dvdt; dmdt; dhdt; dndt];
		end
       
		function HHobj = statemodifier(HHobj)
			if HHobj.S(1,HHobj.samplenumber_current+1) >= HHobj.V_threshold & ...
				HHobj.S(1,HHobj.samplenumber_current) < HHobj.V_threshold, 
				HHobj.spiketimes(end+1) = HHobj.t(HHobj.samplenumber_current+1);
				HHobj.spikesamples(end+1) = HHobj.samplenumber_current+1;
			end
		end

		function V = voltage(HHobj)
			V = HHobj.S(1,:);
		end
        
		function m=mvar(HHobj)
			m=HHobj.S(2,:); %sodium activation
		end
        
		function h=hvar(HHobj)
			h=HHobj.S(3,:); %sodium inactivation
		end
		function n=nvar(HHobj)
			n=HHobj.S(4,:); %potassium activation
		end

		function HHobj = setup_synapses(HHobj)

			if HHobj.SR,
				P_A = 0.43; P_tau1 = 21e-3; P_tau2 = 92e-3; P_B = 1.17;
				P_factor = 0.1;
			else,
				P_A = 2.47; P_tau1 = 6.4e-3; P_tau2 = 64e-3; P_B = 0.04;
				P_factor = 1;
			end;

			[HHobj.Total_AMPA_G,p1] = vlt.neuroscience.models.synapses.probabilistic_release(...
				't_start', HHobj.t_start, 't_end', HHobj.t_end, 'dt', HHobj.dt, ...
				'facilitation_increase', HHobj.facilitation, ...
				'facilitation_tau', HHobj.facilitation_tau, ...
				'presyn_times', HHobj.ESyn1_times, ...
				'N',HHobj.GLUT_PNQ(2), 'P', P_factor*HHobj.GLUT_PNQ(1), ...
				'Q',HHobj.GLUT_PNQ(3), 'V_recovery_time',HHobj.V_recovery_time,...
				'syn_tau1',0.001, 'syn_tau2', 0.005, ... % AMPA kinetics
				'P_A', P_A, 'P_tau1', P_tau1, 'P_B', P_B, 'P_tau2', P_tau2 ...
				);

			[Total_AMPA_G2,p2] = vlt.neuroscience.models.synapses.probabilistic_release(...
				't_start', HHobj.t_start, 't_end', HHobj.t_end, 'dt', HHobj.dt, ...
				'facilitation_increase', HHobj.facilitation, ...
				'facilitation_tau', HHobj.facilitation_tau, ...
				'presyn_times', HHobj.ESyn2_times, ...
				'N',HHobj.GLUT_PNQ(2), 'P', P_factor*HHobj.GLUT_PNQ(1), ...
				'Q',HHobj.GLUT_PNQ(3), 'V_recovery_time',HHobj.V_recovery_time,...
				'syn_tau1',0.001, 'syn_tau2', 0.005, ... % AMPA kinetics
				'P_A', P_A, 'P_tau1', P_tau1, 'P_B', P_B, 'P_tau2', P_tau2 ...
				);
			HHobj.Total_AMPA_G = HHobj.Total_AMPA_G + Total_AMPA_G2;

			HHobj.Total_NMDA_G = vlt.neuroscience.models.synapses.probabilistic_release(...
				'Released_times', p1.Released_times, ...
				'Q',HHobj.GLUT_PNQ(3) * 0.50, ... % NMDA will be 50% of AMPA
				'syn_tau1',0.005, 'syn_tau2', 0.050 ... % NMDA kinetics
				);
			HHobj.Total_NMDA_G = HHobj.Total_NMDA_G + vlt.neuroscience.models.synapses.probabilistic_release(...
				'Released_times', p2.Released_times, ...
				'Q',HHobj.GLUT_PNQ(3) * 0.50, ... % NMDA will be 50% of AMPA
				'syn_tau1',0.005, 'syn_tau2', 0.050 ... % NMDA kinetics
				);

			HHobj.Total_GABA_G = vlt.neuroscience.models.synapses.probabilistic_release(...
				't_start', HHobj.t_start, 't_end', HHobj.t_end, 'dt', HHobj.dt, ...
				'presyn_times', HHobj.ISyn_times, ...
				'N',HHobj.GABA_PNQ(2), 'P', P_factor*HHobj.GABA_PNQ(1), ...
				'Q',HHobj.GABA_PNQ(3), 'V_recovery_time',HHobj.V_recovery_time,...
				'syn_tau1',0.001, 'syn_tau2', 0.020, ... % GABA kinetics
				'P_A', P_A, 'P_tau1', P_tau1, 'P_B', P_B, 'P_tau2', P_tau2 ...
				);

			if ~HHobj.AMPA,
				HHobj.Total_AMPA_G = HHobj.Total_AMPA_G * 0;
			end;
			if ~HHobj.NMDA,
				HHobj.Total_NMDA_G = HHobj.Total_NMDA_G * 0;
			end;
			if ~HHobj.GABA,
				HHobj.Total_GABA_G = HHobj.Total_GABA_G * 0;
			end;

		end



	end % Methods
    
end % classdef 

