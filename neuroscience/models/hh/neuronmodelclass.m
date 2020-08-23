
% developed by Steve Van Hooser and Ishaan Khurana


classdef neuronmodelclass
    
	properties

		Cm;
		Rm;
		E_leak;
		dt;
		t_start;
		t_end;
		f;
		samplenumber_current;
		update_method;
		S;  % state vector, D-dimensions x t where t is timesteps
		I;  % applied current
		t;  

		step1_time;       % what time should we make first step?
		step2_time;       % what time should we make second step?
		step1_value;      % what value should we step to first?
		step2_value;      % what value should we step to second?

		involtageclamp;   % are we in voltage clamp?

	end

	methods
		function neuronmodel_obj = neuronmodelclass(varargin)
		    
			Cm = 100e-12;
			Rm = 10e6;
			E_leak = -0.070;
			dt = 1e-6;
			t_start = -0.1;
			t_end = 0.75;
			f=4;
			samplenumber_current = 1;
			update_method = 'Runge Kutta';

			step1_time = 0;
			step2_time = 0.500;
			step1_value = 1e-9;
			step2_value = 0;
			    
			assign(varargin{:});
			t = t_start:dt:t_end;
			I = zeros(size(t));
			S = zeros(size(t));
			neuronmodel_obj.Cm=Cm;
			neuronmodel_obj.Rm=Rm;
			neuronmodel_obj.E_leak=E_leak;
			neuronmodel_obj.dt=dt;
			neuronmodel_obj.t_start=t_start;
			neuronmodel_obj.t_end=t_end;
			neuronmodel_obj.f=f;
			neuronmodel_obj.samplenumber_current=samplenumber_current;
			neuronmodel_obj.update_method=update_method;
			neuronmodel_obj.S=S;
			neuronmodel_obj.t=t;
			neuronmodel_obj.I=I;
		end
        
		function neuronmodel_obj = setup_current(neuronmodel_obj, varargin)
			I_rand = 0;
			A = 0; % sinewave amplitude
			f = neuronmodel_obj.f;
    
			assign(varargin{:});

			neuronmodel_obj.I = zeros(size(neuronmodel_obj.t));
			step1_start_sample = find(...
				neuronmodel_obj.t(1:end-1)<=neuronmodel_obj.step1_time & ...
				neuronmodel_obj.t(2:end)>neuronmodel_obj.step1_time);
			step1_stop_sample = find(...
				neuronmodel_obj.t(1:end-1)<=neuronmodel_obj.step2_time & ...
				neuronmodel_obj.t(2:end)>neuronmodel_obj.step2_time);
			step2_start_sample = step1_stop_sample;
			step2_stop_sample = numel(neuronmodel_obj.t);

			neuronmodel_obj.I(step1_start_sample:step1_stop_sample) = ...
				neuronmodel_obj.step1_value;
			neuronmodel_obj.I(step2_start_sample:step2_stop_sample) = ...
				neuronmodel_obj.step2_value;

			% now add sin wave
			t_shift = neuronmodel_obj.t - neuronmodel_obj.t(step1_start_sample);
			t_shift(step2_start_sample:step2_stop_sample) = -1;
			neuronmodel_obj.I=neuronmodel_obj.I+A*(t_shift>=0).*sin(2*pi*f*t_shift);
			
			% now add randomness
			neuronmodel_obj.I=neuronmodel_obj.I+...
				(t_shift>=0).*I_rand.*randn(size(neuronmodel_obj.I));
		end
        
		function neuronmodel_obj = simulate(neuronmodel_obj)
			% perform a simulation
            
			switch(neuronmodel_obj.update_method),
				case 'Euler',
					for i = 1:numel(neuronmodel_obj.t)-1
						neuronmodel_obj.samplenumber_current = i;
						neuronmodel_obj.S(:,neuronmodel_obj.samplenumber_current+1) = ...
							neuronmodel_obj.S(:,neuronmodel_obj.samplenumber_current) +...
							neuronmodel_obj.dsdt(neuronmodel_obj.S(:,neuronmodel_obj.samplenumber_current))*neuronmodel_obj.dt;
						neuronmodel_obj=neuronmodel_obj.statemodifier();
					end;
				case 'Runge Kutta',
					for i = 1:numel(neuronmodel_obj.t)-1
						neuronmodel_obj.samplenumber_current = i;
						y=neuronmodel_obj.S(:,neuronmodel_obj.samplenumber_current);
						k1=neuronmodel_obj.dt*dsdt(neuronmodel_obj,y)/6;
						k2=neuronmodel_obj.dt*dsdt(neuronmodel_obj,y+k1/2)/3;
						k3=neuronmodel_obj.dt*dsdt(neuronmodel_obj,y+k2/2)/3;
						k4=neuronmodel_obj.dt*dsdt(neuronmodel_obj,y+k3)/6;
						neuronmodel_obj.S(:,neuronmodel_obj.samplenumber_current+1)=y+k1+k2+k3+k4;
						neuronmodel_obj=neuronmodel_obj.statemodifier();
					end;
			end;
		end
        
            
		function dsdt = dsdt(neuronmodel_obj, S_value)
			dsdt = 0;
		end
      
		function neuronmodel_obj = statemodifier(neuronmodel_obj)
			% nothing to do in base class
		end
 
	end % methods
end % classdef
