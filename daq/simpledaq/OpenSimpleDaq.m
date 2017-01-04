function newsd = OpenSimpleDaq(sd)

% OPENSIMPLEDAQ - Opens a SimpleDaq device
%
%     NEWSD = OPENSIMPLEDAQ(SD)
%
%  Calls the open function for the SimpleDaq device SD.
%
%    Literally returns NEWSD = SD.daqname_OpenSimpleDaq(SD)
%

eval(['newsd = ' sd.daqname '_OpenSimpleDaq(sd);']);
