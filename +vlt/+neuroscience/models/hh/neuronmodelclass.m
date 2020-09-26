
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
		I;  % current
		t;  
		command; % whatever is commanded, current or voltage

		step1_time;       % what time should we make first step?
		step2_time;       % what time should we make second step?
		step1_value;      % what value should we step to first?
		step2_value;      % what value should we step to second?

		involtageclamp;   % are we in voltage clamp?
		V_initial;


	end

	methods
		function neuronmodel_obj = neuronmodelclass(varargin)
			V_initial = -0.065;
			Cm = 100e-12;
			Rm = 10e6;
			E_leak = -0.070;
			dt = 1e-4;
			t_start = -0.1;
			t_end = 0.75;
			f=4;
			samplenumber_current = 1;
			update_method = 'Runge Kutta';
			involtageclamp = 0;

			step1_time = 0;
			step2_time = 0.500;
			step1_value = 1e-9;
			step2_value = 0;
			    
			assign(varargin{:});
			t = t_start:dt:t_end;
			I = zeros(size(t));
			command = zeros(size(t));
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
			neuronmodel_obj.command = command;
			neuronmodel_obj.involtageclamp = involtageclamp;
			neuronmodel_obj.V_initial = V_initial;
		end
        
		function neuronmodel_obj = setup_command(neuronmodel_obj, varargin)
			I_rand = 0;
			A = 0; % sinewave amplitude
			f = neuronmodel_obj.f;
    
			assign(varargin{:});

			neuronmodel_obj.command = zeros(size(neuronmodel_obj.t));
			if neuronmodel_obj.involtageclamp,
				neuronmodel_obj.command = neuronmodel_obj.command + neuronmodel_obj.V_initial;
			end;

			if neuronmodel_obj.step1_time <= neuronmodel_obj.t(1),
				step1_start_sample = 1;
			elseif neuronmodel_obj.step1_time >= neuronmodel_obj.t(end), 
				step1_start_sample = numel(neuronmodel_obj.t);
			else,
				step1_start_sample = find(...
					neuronmodel_obj.t(1:end-1)<=neuronmodel_obj.step1_time & ...
					neuronmodel_obj.t(2:end)>neuronmodel_obj.step1_time);
			end;

			if neuronmodel_obj.step2_time <= neuronmodel_obj.t(1),
				step1_stop_sample = 1;
			elseif neuronmodel_obj.step2_time >= neuronmodel_obj.t(end),
				step1_stop_sample = numel(neuronmodel_obj.t);
			else,
				step1_stop_sample = find(...
					neuronmodel_obj.t(1:end-1)<=neuronmodel_obj.step2_time & ...
					neuronmodel_obj.t(2:end)>neuronmodel_obj.step2_time);
			end;
			step2_start_sample = step1_stop_sample;
			step2_stop_sample = numel(neuronmodel_obj.t);

			if step1_start_sample <= numel(neuronmodel_obj.t),
				neuronmodel_obj.command(step1_start_sample:step1_stop_sample) = ...
					neuronmodel_obj.step1_value;
			end;
			if step1_stop_sample <= numel(neuronmodel_obj.t),
				% only apply this if we have a second interval
				neuronmodel_obj.command(step2_start_sample:step2_stop_sample) = ...
					neuronmodel_obj.step2_value;
			end;

			% now add sin wave
			t_shift = neuronmodel_obj.t - neuronmodel_obj.t(step1_start_sample);
			t_shift(step2_start_sample:step2_stop_sample) = -1;
			neuronmodel_obj.command=neuronmodel_obj.command+A*(t_shift>=0).*sin(2*pi*f*t_shift);
			
			% now add randomness
			neuronmodel_obj.command=neuronmodel_obj.command+...
				(t_shift>=0).*I_rand.*randn(size(neuronmodel_obj.command));
		end
        
		function neuronmodel_obj = simulate(neuronmodel_obj)
			% perform a simulation

			if neuronmodel_obj.involtageclamp,
				neuronmodel_obj.S(1,:) = neuronmodel_obj.command;
				updatestates = [2:size(neuronmodel_obj.S,1)];
			else,
				neuronmodel_obj.I = neuronmodel_obj.command;
				updatestates = [1:size(neuronmodel_obj.S,1)];
			end;

			switch(neuronmodel_obj.update_method),
				case 'Euler',
					for i = 1:numel(neuronmodel_obj.t)-1
						neuronmodel_obj.samplenumber_current = i;
						[dsdt_,Ihere] = neuronmodel_obj.dsdt(neuronmodel_obj.S(:,...
							neuronmodel_obj.samplenumber_current));
						newState = neuronmodel_obj.S(:,neuronmodel_obj.samplenumber_current) + ...
							dsdt_*neuronmodel_obj.dt;
						neuronmodel_obj.S(updatestates,neuronmodel_obj.samplenumber_current+1) = ...
							newState(updatestates);
						if neuronmodel_obj.involtageclamp,
							neuronmodel_obj.I(neuronmodel_obj.samplenumber_current+1) = -Ihere;
						end;
						neuronmodel_obj=neuronmodel_obj.statemodifier();
					end;
				case 'Runge Kutta',
					for i = 1:numel(neuronmodel_obj.t)-1
						neuronmodel_obj.samplenumber_current = i;
						y=neuronmodel_obj.S(:,neuronmodel_obj.samplenumber_current);
						[dsdt_,Ihere] = dsdt(neuronmodel_obj,y);
						k1=neuronmodel_obj.dt*dsdt_/6;
						k2=neuronmodel_obj.dt*dsdt(neuronmodel_obj,y+k1/2)/3;
						k3=neuronmodel_obj.dt*dsdt(neuronmodel_obj,y+k2/2)/3;
						k4=neuronmodel_obj.dt*dsdt(neuronmodel_obj,y+k3)/6;
						newState = y+k1+k2+k3+k4;
						neuronmodel_obj.S(updatestates,neuronmodel_obj.samplenumber_current+1)= ...
							newState(updatestates);
						if neuronmodel_obj.involtageclamp,
							neuronmodel_obj.I(neuronmodel_obj.samplenumber_current+1) = -Ihere;
						end;
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
