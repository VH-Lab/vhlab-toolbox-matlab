# vlt.data.conditiongroup2cell

   CONDITIONGROUP2VALUE - Convert a condition grouping matrix to a cell.
 
   [DATA, EXPER_INDEXES] = vlt.data.conditiongroup2cell(VALUES, EXPERIMENT_INDEXES, CONDITION_INDEXES)
 
   Given an array of values VALUES, and another array EXPERIMENT_INDEXES that describes
   (with an index number) the experiment number that produced each entry of VALUES,
   and another array CONDITION_INDEXES that describes (with an index number) the
   experimental condition of each observation in VALUES, this function produces
   
   DATA - a cell array with the number of entries equal to the number of unique values of
    CONDITION_INDEXES. Each entry has a matrix of VALUES from that condition.
   EXPER_INDEXES - a cell array with the number of entries equal to the number of
    unique values of CONDITION_INDEXES. Each entry EXPER_INDEXES{n}(i) describes the
   experiment index number that produced the observation DATA{n}(i)
    
   This function is useful for preparing data in the form expected by vlt.plot.median_within_between_plot
 
   The documentation is way longer than the code.
