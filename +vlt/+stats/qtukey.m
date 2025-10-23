function x = qtukey(v, k, p)
%vlt.stats.qtukey Tukey's q studentized range critical value.
%
%   X = vlt.stats.qtukey(V,K,P) finds the Tukey's q studentized range
%   critical value.
%
%   This function is part of the 'vlt' package and is an adaptation of
%   the FEX file 3469 by A. Trujillo-Ortiz and R. Hernandez-Walls.
%
%   This modified macro (based on the Fortran77 algorithm AS 190.2
%   Appl. Statist. (1983)) gives a very good approximation for
%   0.8 < p < 0.995.
%
%   Syntax: function x = vlt.stats.qtukey(v,k,p)
%
%   Inputs:
%       v - sample degrees of freedom (must be the same for each sample).
%       k - number of samples.
%       p - cumulative probability value (default = 0.95).
%
%   Outputs:
%       x - The critical q-value.
%
%   Original FEX citation:
%   Trujillo-Ortiz, A. and R. Hernandez-Walls. (2003). qtukey: Tukey's q
%     studentized range critical value. A MATLAB file. [WWW document].
%     URL http://www.mathworks.com/matlabcentral/fileexchange/3469
%
%   References:
%   Algorithm AS 190.2 (1983), Applied Statistics, 32(2)
%

% --- Updated to use standard arguments block validation ---
arguments
    v (1,1) double {mustBeNumeric}
    k (1,1) double {mustBeInteger, mustBeGreaterThan(k, 1)}
    p (1,1) double {mustBeNumeric, mustBeGreaterThan(p, 0), mustBeLessThan(p, 1)} = 0.95
end
% --- End arguments block ---


if v < 1
    warning('MATLAB:User:Warning','Degrees of freedom v < 1, results may be unreliable.');
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
    % *** BUG FIX (from original FEX 3469) ***
    % The original code would error if v > 120 because 'qc' was
    % only defined inside the 'if' block. This 'else' block
    % provides the correct approximation for large v.
    q = c(1) - c(2) * t;
    qc = t * (q * log(k-1) + c(5));
end

x = qc;

end
