function newsd = CloseSimpleDaq(sd)

% vlt.daq.simpledaq.CloseSimpleDaq - Closes a SimpleDaq device
%
%     NEWSD = vlt.daq.simpledaq.CloseSimpleDaq(SD)
%
%  Calls the close function for the SimpleDaq device SD.
%
%    Literally returns NEWSD = SD.daqname_CloseSimpleDaq(SD)
%

eval(['newsd = ' sd.daqname '_CloseSimpleDaq(sd);']);
