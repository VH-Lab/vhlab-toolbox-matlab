function n_out = numornan(n_in, dims)
% VLT.DATA.NUMORNAN - Return a number, or a NaN if the input is empty
%
%   N_OUT = vlt.data.numornan(N_IN)
%   N_OUT = vlt.data.numornan(N_IN, DIMS)
%
%   This function checks if the input N_IN is empty.
%   - If N_IN is not empty, it returns N_IN.
%   - If N_IN is empty, it returns a NaN value.
%
%   If the optional argument DIMS is provided, the returned NaN will have the
%   specified dimensions. If N_IN is not empty but smaller than DIMS, it will
%   be padded with NaNs to match DIMS.
%
%   Example:
%       vlt.data.numornan(5)          % returns 5
%       vlt.data.numornan([])         % returns NaN
%       vlt.data.numornan([], [2 2])  % returns a 2x2 matrix of NaNs
%
%   See also: ISNAN, ISEMPTY
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
	if ~vlt.data.eqlen(sz,dims),
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
 
