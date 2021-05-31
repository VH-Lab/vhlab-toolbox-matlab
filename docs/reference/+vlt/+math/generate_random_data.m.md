# vlt.math.generate_random_data

 GENERATE_RANDOM_DATA Produce data from different distributions
    DATA=vlt.math.generate_random_data(N, DIST, PARAM1, PARAM2, ...)
 
  Generates data from different distributions.
 
    Inputs:  N - the number of data points to produce.
             DIST - the distribution string; see HELP ICDF
                Examples: 'Normal', 'Uniform'
             PARAM1 - The first parameter of the distribution
             PARAM2 - The second parameter of the distribution
                         (see HELP ICDF)
    Outputs: DATA - N data points from the distribution.
