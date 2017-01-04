function [ data ] = generate_random_data(N, distribution, varargin)
%GENERATE_RANDOM_DATA Produce data from different distributions
%   DATA=GENERATE_RANDOM_DATA(N, DIST, PARAM1, PARAM2, ...)
%
% Generates data from different distributions.
%
%   Inputs:  N - the number of data points to produce.
%            DIST - the distribution string; see HELP ICDF
%               Examples: 'Normal', 'Uniform'
%            PARAM1 - The first parameter of the distribution
%            PARAM2 - The second parameter of the distribution
%                        (see HELP ICDF)
%   Outputs: DATA - N data points from the distribution.

data = icdf(distribution,rand(N,1),varargin{:});