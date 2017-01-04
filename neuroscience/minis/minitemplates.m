function [mt,t,params] = minitemplates(varargin)
%
%  [MT,T,PARAMS] = MINITEMPLATES(...)
%
%  Returns several rows of mini EPSC templates, ranging in amplitude from
%  0.1 to 1 in amplitude, and with a range of tau onsets and offsets.
%
%  T is a series of time points that can be used to plot the templates.
%
%  PARAMS is a structure that has one entry per template that indicates
%  the Tau_Onset, Tau_Offset, and amplitude used.
%  
%  This function takes name/value pairs to modify its default behavior.
%  Parameter (default)      | Description
%  -----------------------------------------------------------------------
%  Min_Amplitude (0.1)      | The minimum amplitude to use
%  Max_Amplitude (3)        | The maximum amplitude to use
%  Amplitude_Steps (9)      | The number of amplitude steps from min to max
%  Tau_Onsets ([0.001;      | The range of Tau_Onset values to use (seconds)
%             0.003;])      |
%  Tau_Offsets ([0.010;     | The range of Tau_Offset values to use (seconds)
%    0.020; 0.030]);        |  
%  t0 (0)                   | The time of the first sample in each template (seconds)
%  t1 (0.100)               | The time of the last sample in each template (seconds)
%  dt (0.001)               | The time interval between samples (seconds)


Min_Amplitude = 0.1;
Max_Amplitude = 1;
Amplitude_Steps = 9;
Tau_Onsets = [0.001; 0.003];
Tau_Offsets = [0.010; 0.020; 0.030];

t0 = 0; 
t1 = 0.100;
dt = 0.001;

assign(varargin{:});


params = emptystruct('Amplitude','Tau_Onset','Tau_Offset');

t = t0:dt:t1;

mt = zeros(0,length(t));

A = linspace(Min_Amplitude,Max_Amplitude,Amplitude_Steps);

for a = 1:length(A),
	for t1 = 1:length(Tau_Onsets),
		for t2 = 1:length(Tau_Offsets),
			mt(end+1,:) = (exp(-t/Tau_Offsets(t2))-exp(-t/Tau_Onsets(t1)));
			mt(end,:) = A(a) * (mt(end,:)./max(mt(end,:)));
            params(end+1) = struct('Amplitude',A(a),'Tau_Onset',Tau_Onsets(t1),'Tau_Offset',Tau_Offsets(t2));
		end;
	end;
end;


