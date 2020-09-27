

  % developed by Steve Van Hooser and Ishaan Khurana, with code from 
  % _An Introductory Course in Computational Neuroscience_ by Paul Miller


classdef vlt.neuro.models.hh.HHclass < vlt.neuro.models.hh.neuronmodelclass
    
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
	end
    
	methods
		function HHobj = vlt.neuro.models.hh.HHclass(varargin)
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
			vlt.data.assign(varargin{:});

			HHobj = HHobj@vlt.neuro.models.hh.neuronmodelclass(varargin{:});
			HHobj.V_threshold = V_threshold; 
			HHobj.dt = dt;
			HHobj.t = HHobj.t_start:HHobj.dt:HHobj.t_end;
			HHobj.S = zeros(4,numel(HHobj.t));
			HHobj.spiketimes = []; % must be initialized to empty
			HHobj.spikesamples = []; % must be initialized to empty
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
				Itot = I_L+I_Na+I_K+HHobj.I(HHobj.samplenumber_current); % total current is sum of leak + active channels + applied current
			else,
				Itot = I_L+I_Na+I_K;
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
	end
    
end % classdef 

