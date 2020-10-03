function sd = NewSimpleDaq(name, parameters)

% vlt.daq.simpledaq.NewSimpleDaq - Creates a new SimpleDaq object
%
%  SD = vlt.daq.simpledaq.NewSimpleDaq(DAQNAME, PARAMETERS)
%
%  Returns a structure with fieldnames 'daqname' and 'parameters', set to
%  the string DAQNAME and the variable PARAMETERS, respectfully.
%
%  This structure can then be passed to the SimpleDAQ commands such as
%     vlt.daq.simpledaq.OpenSimpleDaq
%     vlt.daq.simpledaq.CloseSimpleDaq
%     vlt.daq.simpledaq.AcquireSimpleDaq
%
%  SimpleDaq is a wrapper class for many types of aqcusition devices.  When
%  one calls vlt.daq.simpledaq.OpenSimpleDaq, vlt.daq.simpledaq.OpenSimpleDaq will in turn call
%    DAQNAME_OpenSimpleDaq(DAQNAME, PARAMETERS)
% 


sd.daqname = name;
sd.parameters = parameters;
