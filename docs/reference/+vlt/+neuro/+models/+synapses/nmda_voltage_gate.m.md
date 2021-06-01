# vlt.neuro.models.synapses.nmda_voltage_gate

  NMDA_VOLTAGE_GATE - voltage gate for NMDA channels, dependent on Mg block
 
  G = vlt.neuro.models.synapses.nmda_voltage_gate(V)
  
  Returns a simulated gating variable based on the NMDA voltage dependence as
  measured from Mayar, Westbrook, and Guthrie 1984.
 
  At V = 0 volts, the gating variable is 1. It goes up and down according to 
  Figure 3C of the paper. For example, at V = -0.080 volts, g is 0.0564.
  At V = 0.020 V, g is 1.2359.
