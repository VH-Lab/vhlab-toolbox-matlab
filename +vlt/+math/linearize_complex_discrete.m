function [y, indexes, set] = linearize_complex_discrete(x, varargin)
% LINEARIZE_COMPLEX_DISCRETE - create a linear plot by concatenating discrete complex elements
%
% [Y, INDEXES, SET] = LINEARIZE_COMPLEX_DISCRETE(X, ...)
%
% Given an array X of complex-valued elements that correspond to discrete sets of real, imaginary pairs,
% this function creates a linearized array Y where the real values are repeated in a linear fashion with
% gap GAP. INDEXES indicate which entry in X corresponds to each entry in Y. SET indicates which set of the
% imaginary values each point is associated with (where the imaginary values are sorted from least (first set)
% to greatest (nth set)).
%  
% If there is a real, imaginary pair value that is missing, then NaN will be filled in Y and INDEXES.
%
% This function can be modified by passing parameters as name/value pairs:
% Parameter (default value)    | Description 
% -----------------------------------------------------------------------
% GAP (1)                      | The gap between successive steps of the imaginary values
% EPSILON (1e-10)              | How close values must be in order to be considered the "same"
% 
% See also: REAL, IMAG, NAMEVALUEPAIR
%
% Example:
%    X = [ [1 2 3] [1 2 3]+sqrt(-1) [1 2 3]+2*sqrt(-1) ]
%    [Y, IND] = linearize_complex_discrete(X, 1) 
%      % Y = [ [1 2 3]  [4 5 6] [7 8 9] ]', 
%      % IND = [ [1 2 3] [4 5 6] [7 8 9] ]', 
%      % SET = [ [1 1 1] [2 2 2] [3 3 3] ]'

gap = 1;
epsilon = 1e-10;

assign(varargin{:});

imag_values = unique(imag(x));
real_values = unique(real(x));

segment_length = max(real_values) - min(real_values) + gap;

indexes = [];
y = [];
set = [];

 % account for the possibility that the sets are not all complete, fill incompletes with NaN

for i=1:numel(imag_values),
	for j=1:numel(real_values),
		target = real_values(j) + sqrt(-1)*imag_values(i);
		[index_here,v] = findclosest(x(:), target);
		if abs(v-target)<epsilon,
			y(end+1) = real_values(j) + segment_length*(i-1);
			indexes(end+1) = index_here;
			set(end+1) = i;
		else,
			y(end+1) = NaN;
			indexes(end+1) = NaN;
			set(end+1) = NaN;
		end
	end

end

 % return as columns
y = y(:);
indexes = indexes(:); 
set = set(:);
