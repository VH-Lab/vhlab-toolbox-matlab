function g = nmda_voltage_gate(v)
% NMDA_VOLTAGE_GATE - voltage gate for NMDA channels, dependent on Mg block
%
% G = vlt.neuroscience.models.synapses.nmda_voltage_gate(V)
% 
% Returns a simulated gating variable based on the NMDA voltage dependence as
% measured from Mayar, Westbrook, and Guthrie 1984.
%
% At V = 0 volts, the gating variable is 1. It goes up and down according to 
% Figure 3C of the paper. For example, at V = -0.080 volts, g is 0.0564.
% At V = 0.020 V, g is 1.2359.
%

  % obs courtesy DataThief III
obs = [ -70.2447, 8.72
-59.267, 13.7544
-49.725, 20.1686
-39.4465, 27.2602
-29.5548, 32.6458
-18.936, 38.0251
-9.7715, 43.4169
0.1014, 47.435
9.9649, 50.7694
20.6351, 59.9091
30.5873, 69.7386];

obs(:,1) = obs(:,1)*1e-3; % convert to volts

if 0,   % if we need to recalculate
	[slope,offset] = vlt.stats.quickregression(obs(:,1),obs(:,2),0.05);
else,
	slope = 5.744302046472411e+02;
	offset = 48.702079977960830;
end;

g = vlt.math.rectify((slope*v+offset)/offset,0);


