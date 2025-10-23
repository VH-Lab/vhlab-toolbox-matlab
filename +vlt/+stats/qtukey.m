function x = qtukey(v, k, p)
%vlt.stats.qtukey Tukey's q studentized range critical value (quantile).
%
%   x = vlt.stats.qtukey(v, k, p)
%
%   Finds the critical value 'x' (quantile) for the Tukey's q studentized
%   range distribution, given the degrees of freedom (v), number of
%   groups (k), and the cumulative probability (p).
%
%   This function is primarily used to find the critical value for a
%   Tukey's HSD post-hoc test.
%
%   **********************************************************************
%   *** PACKAGE NOTE & CITATION                                        ***
%   **********************************************************************
%   This function is a direct adaptation of 'qtukey.m' from the
%   MATLAB File Exchange (FEX ID: 3469), created by A. Trujillo-Ortiz
%   and R. Hernandez-Walls.
%
%   It has been renamed to 'vlt.stats.qtukey' to be included in the
%   'vlt' package. The original documentation is preserved below.
%
%   PACKAGE MODIFICATION:
%   The original FEX file (version 1.0.0.0) has a bug where the output
%   variable 'qc' is not assigned if v > 120, causing an error. This
%   version includes the standard 'else' block to correct this bug,
%   making the function valid for all v > 0.
%
%   ORIGINAL AUTHORS:
%   A. Trujillo-Ortiz and R. Hernandez-Walls
%   atrujo@uabc.mx
%   Facultad de Ciencias Marinas
%   Universidad Autonoma de Baja California
%
%   TO CITE THE ORIGINAL FILE:
%   Trujillo-Ortiz, A. and R. Hernandez-Walls. (2003). qtukey: Tukey's q
%     studentized range critical value. A MATLAB file.
%     URL: http://www.mathworks.com/matlabcentral/fileexchange/3469
%
%   See also: vlt.stats.cdfTukey, vlt.stats.power.calculateTukeyPairwisePower
%

% --------------------------------------------------------------------
% --- BEGIN ORIGINAL DOCUMENTATION (from FEX 3469) ---
% --------------------------------------------------------------------
%
%QTUKEY Tukey's q studentized range critical value.
%   X = QTUKEY(V,K,P) finds the Tukey's q studentized range critical value.
%(This modified macro based on the Fortran77 algorithm AS 190.2 Appl. Statist. (1983)
%gives a very good approximation for 0.8 < p < 0.995).
%
%   Syntax: function x = qtukey(v,k,p)
%
%     Inputs:
% 	        v - sample degrees of freedom (must be the same for each sample).
% 	        k - number of samples.
% 	        p - cumulative probability value.
%
%  Created by A. Trujillo-Ortiz and R. Hernandez-Walls
%             ... (contact info) ...
%  May 18, 2003.
%
%  References:
%
%  Algorithm AS 190.2 (1983), Applied Statistics, 32(2)
%
% --------------------------------------------------------------------
% --- BEGIN MODIFIED ORIGINAL CODE (from FEX 3469) ---
% --------------------------------------------------------------------

if nargin < 3
    p = 0.95;
end

if nargin < 2
   error('Requires at least two arguments (v, k).');
end

if v < 1
    warning('Degrees of freedom v < 1, results may be unreliable.');
    v = 1;
end

t = norminv(0.5 + 0.5 * p);
vmax = 120;
c = [0.89, 0.237, 1.214, 1.21, 1.414];

if v <= vmax
    t = t + (t*t*t + t) / v / 4;
    q = c(1) - c(2) * t;
    q = q - c(3) / v + c(4) * t / v;
    qc = t * (q * log(k-1) + c(5));
else
    % *** BUG FIX ***
    % This 'else' block is added to handle v > 120, which was
    % missing from the original FEX 3469 file.
    q = c(1) - c(2) * t;
    qc = t * (q * log(k-1) + c(5));
end

x = qc;
