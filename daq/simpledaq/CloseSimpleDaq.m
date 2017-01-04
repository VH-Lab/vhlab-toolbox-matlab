function newsd = CloseSimpleDaq(sd)

% CLOSESIMPLEDAQ - Closes a SimpleDaq device
%
%     NEWSD = CLOSESIMPLEDAQ(SD)
%
%  Calls the close function for the SimpleDaq device SD.
%
%    Literally returns NEWSD = SD.daqname_CloseSimpleDaq(SD)
%

eval(['newsd = ' sd.daqname '_CloseSimpleDaq(sd);']);
