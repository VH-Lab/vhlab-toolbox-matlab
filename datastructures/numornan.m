function n_out = numornan(n_in, dims)
% NUMORNAN - Return a number, or a NaN if the number is empty
%
%  N_OUT = NUMORNAN(N_IN)
%    or 
%  N_OUT = NUMORNAN(N_IN, DIMS)
%
%  If N_IN is not empty, then N_OUT is set to N_IN.
%  If N_IN is empty, then a NaN is returned.
%  
%  If the optional input argument DIMS is provided, then the NaN
%  matrix has dimension DIMS. If N_IN is smaller than DIMS, then
%  N_OUT is padded to be filled with NaN.
%

if nargin<2,
	if ~isempty(n_in),
		dims = size(n_in);
	else,
		dims = [1 1];
	end;
end;

if ~isempty(n_in),
	sz = size(n_in);
	n_out = n_in;
	if ~eqlen(sz,dims),
		for j=1:length(dims),
			if length(sz)<j, sz(j) = 0; end;
			mydims = size(n_out);
			mydims(j) = dims(j) - sz(j),
			n_out, NaN(mydims),
			if mydims(j) < 0,
				error(['NaN dimensions must be greater than or equal to n_in dimensions']);
			end;
			n_out = cat(j, n_out, NaN(mydims));
		end;
	end;
else,
	n_out = NaN(dims);
end;
 
