function sd = NewSimpleDaq(name, parameters)

% NEWSIMPLEDAQ - Creates a new SimpleDaq object
%
%  SD = NEWSIMPLEDAQ(DAQNAME, PARAMETERS)
%
%  Returns a structure with fieldnames 'daqname' and 'parameters', set to
%  the string DAQNAME and the variable PARAMETERS, respectfully.
%
%  This structure can then be passed to the SimpleDAQ commands such as
%     OpenSimpleDaq
%     CloseSimpleDaq
%     AcquireSimpleDaq
%
%  SimpleDaq is a wrapper class for many types of aqcusition devices.  When
%  one calls OpenSimpleDaq, OpenSimpleDaq will in turn call
%    DAQNAME_OpenSimpleDaq(DAQNAME, PARAMETERS)
% 


sd.daqname = name;
sd.parameters = parameters;
