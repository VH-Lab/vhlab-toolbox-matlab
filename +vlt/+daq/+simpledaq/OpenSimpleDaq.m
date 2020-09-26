function newsd = OpenSimpleDaq(sd)

% vlt.daq.simpledaq.OpenSimpleDaq - Opens a SimpleDaq device
%
%     NEWSD = vlt.daq.simpledaq.OpenSimpleDaq(SD)
%
%  Calls the open function for the SimpleDaq device SD.
%
%    Literally returns NEWSD = SD.daqname_OpenSimpleDaq(SD)
%

eval(['newsd = ' sd.daqname '_OpenSimpleDaq(sd);']);
