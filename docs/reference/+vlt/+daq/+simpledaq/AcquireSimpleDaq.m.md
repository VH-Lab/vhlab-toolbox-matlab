# vlt.daq.simpledaq.AcquireSimpleDaq

  vlt.daq.simpledaq.AcquireSimpleDaq - Acquires a SimpleDaq device
 
      [DATA,NEWSD] = vlt.daq.simpledaq.AcquireSimpleDaq(SD)
 
   Calls the acquire function for the SimpleDaq device SD.
 
     Literally returns [DATA,NEWSD] = SD.daqname_AcquireSimpleDaq(SD)
 
    The structure DATA will have the following fields:
 
       starttime   --  the 'clock' value at the beginning of the recording;
                          this is the 6 element vector returned by the Matlab
                          function CLOCK
       data        --  a cell list of all data records, the ith of which is
                       a matrix with entries [t_i; data_i_1; data_i_2; ...]
                       where t_i indicates the sample times of data record i
                       (usually with respect to starttime; that is 0==starttime)
                       and data_i_n is the value sampled on channel n.
