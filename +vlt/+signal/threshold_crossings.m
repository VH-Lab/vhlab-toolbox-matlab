function [ index_values ] = theshold_crossings( input, threshold )
%THRESHOLD_CROSSINGS Detect threshold crossings in data
% 
%  INDEX_VALUES = vlt.signal.threshold_crossings(INPUT, THRESHOLD)
%
%  Finds all places where the data INPUT transitions from below
%  the threshold THRESHOLD to be equal to or above the threshold
%  THRESHOLD.  The index values where this occurs are returned in
%  INDEX_VALUES.
%

index_values = 1+find( input(1:end-1)<threshold & input(2:end) >= threshold);
