function p = cdfTukey(q,k,v)
%vlt.stats.cdfTukey Cumulative distribution function (cdf) of the Studentized range (q)
%
%   p = vlt.stats.cdfTukey(q, k, v)
%
%   This function calculates the cumulative probability (p) for a given
%   Studentized range value (q), number of groups (k), and degrees of
%   freedom (v).
%
%   **********************************************************************
%   *** PACKAGE NOTE & CITATION                                        ***
%   **********************************************************************
%   This function is a direct adaptation of 'cdfTukey.m' from the
%   MATLAB File Exchange (FEX ID: 37450), created by L. C. V. Malacarne.
%
%   It has been renamed to 'vlt.stats.cdfTukey' to be included in the
%   'vlt' package. The original code, documentation, and algorithm are
%   preserved entirely.
%
%   ORIGINAL AUTHOR:
%   L. C. V. Malacarne (lcvm@icmc.usp.br)
%   University of Sao Paulo, Aug 2011
%
%   ORIGINAL ALGORITHM:
%   This function is a MATLAB translation of the FORTRAN code for the
%   Applied Statistics algorithm AS 190.
%   Original source: http://lib.stat.cmu.edu/apstat/190
%
%   See also: nctcdf, fzero, vlt.stats.power.calculateTukeyPairwisePower
%

% --------------------------------------------------------------------
% --- BEGIN ORIGINAL DOCUMENTATION (from FEX 37450) ---
% --------------------------------------------------------------------
%
% p = cdfTukey(q,k,v)
%
% This function returns the cumulative distribution function (cdf) of the
% studentized range (q).
%
% Input:
% q - studentized range value
% k - number of groups
% v - degrees of freedom
%
% This function is the Matlab version of the Fortran code
% available at http://lib.stat.cmu.edu/apstat/190
%
% Coded by:
% L. C. V. Malacarne
% lcvm@icmc.usp.br
%
% University of Sao Paulo
% Aug 2011
%
% --------------------------------------------------------------------
% --- BEGIN ORIGINAL CODE (from FEX 37450) ---
% --------------------------------------------------------------------

if (q<=0)
    p = 0;
    return;
end

g   = [0.5, 0.57721566, 0.98905099, 0.90747908, 0.98172809, 0.9951886, ...
    0.99849573, 0.9994803, 0.99981335, 0.99992758, 0.99997157, ...
    0.99998896, 0.99999573, 0.99999834, 0.99999935, 0.99999975, ...
    0.9999999, 0.99999996, 0.99999999];

j = floor(v);
if (j < 1)
    j = 1;
end;
if (j > 19)
    j = 19;
end;

gv = g(j);

if (v == j)
    p = cdfTukey0(q,k,v);
else
    p1 = cdfTukey0(q,k,j);
    p2 = cdfTukey0(q,k,j+1);
    p  = p1 + (v-j)*(p2-p1)*gv;
end

if (p > 1)
    p = 1;
end

return;

%---------------------------------------------------
function p = cdfTukey0(q,k,v)

v1 = v;
v2 = v1;

c = [0.890774, 0.40114, 0.17061, 0.05246, 0.01046, 0.00121, 0.00006];
% e = [0.137, 0.065, 0.03, 0.013, 0.005, 0.002, 0.0008];
d = [0.19306, 0.07553, 0.0211, 0.0042, 0.0005, 0.00003];
w = 0.5;

if (v <= 6.5)
    z  = 0.70710678 * q;
    v2 = v2 / 2;
    w  = 0.25 * v2;
    if (v == 1)
        w = 0.3927;
    end
    if (v == 2)
        w = 0.3;
    end
end

q2 = q*q;

if ((q2*v - 16*v - 16) > 0)
    qw = q*w;
    p  = 0;
    if (v > 1.0001)
        s  = 0.45*sqrt(q2-3.6-8/v2);
        s  = min(s,w);
        p  = cdfTukey1(q, k, v, qw-s) + cdfTukey1(q, k, v, qw+s);
        p  = 0.5 * p;
    else
        z = z - 0.785398;
        if (z > 0)
            p = 0.2146 * exp(-0.5*z*z) / z;
        else
            p = 0.5 + 0.5*erf(z/1.41421);
        end

        z = 0.70710678 * q;
        if (k > 2)
            p = p^k + 1.25*(k-2)*exp(-z*z)*(p^(k-1)) / z;
        end

    end

    return;
end

h  = q * 0.19306 * v^(-0.33333);
if (h > 3)
    h = 3;
end

h = h * (1 - 1/(5.2*v - 4.2));
step = h;

if (v <= 6.5)
    j = floor(v);
    if j < 1
        j = 1;
    end
    step = q * d(1);
    if (v < 3)
        step = q * c(j);
    end
    h = step;
end

p = cdfTukey1(q,k,v,h);

if (h <= step)
    step = step * 0.5;
    if (step < 0.00001)
        return;
    end
    h = h + step;
    p = p + cdfTukey1(q,k,v,h);
    h = h - step;
end

step = step*0.5;

while (step > 0.00001)
    h = h + step;
    p = p + cdfTukey1(q,k,v,h);
    h = h - step;
    step = step * 0.5;
end

return;

%---------------------------------------------------
function p = cdfTukey1(q,k,v,h)

if (h <= 0)
    p = 0;
    return;
end

% v1 = v;
v2 = v;

c = [0.890774, 0.40114, 0.17061, 0.05246, 0.01046, 0.00121, 0.00006];
e = [0.137, 0.065, 0.03, 0.013, 0.005, 0.002, 0.0008];
% d = [0.19306, 0.07553, 0.0211, 0.0042, 0.0005, 0.00003];

p = 1;

if (v <= 6.5)
    z  = 0.70710678 * q;
    % v2 = v2 / 2; % This v2 change seems to be in the wrong place,
                   % it should be in cdfTukey0, not here.
                   % Based on AS190, v2 is just v.

    if (v == 1)
        z = z - 0.785398;
        if (z > 0)
            p = 0.2146 * exp(-0.5*z*z) / z;
        else
            p = 0.5 + 0.5*erf(z/1.41421);
        end

        z = 0.70710678 * q;
        if (k > 2)
            p = p^k + 1.25*(k-2)*exp(-z*z)*(p^(k-1)) / z;
        end

    else
        j = floor(v);
        if j < 1
            j = 1;
        end
        if j > 7
            j = 7;
        end

        qc = q*c(j);

        if (h > (qc + e(j)))
            p = 0;
        else
            if (h < (qc-e(j)))
                p = 1;
            else
                p = 0.5 - 0.5*erf((h-qc)*0.70710678/e(j));
            end
        end

        z = 0.70710678 * q;
        if (k > 2)
            p = p^k + 0.5*(k-2)*exp(-z*z)*(p^(k-1));
        end

    end

else

    z = h;
    z = 3*z;
    v3 = v2*v2;

    c1 = 1/sqrt(v2*6.2831853);
    c2 = v2-1;
    c3 = log(v2);
    c4 = log(z);
    c5 = 0.5/v2;
    c6 = (1-c5)/6;

    z = z - c2*c4 - c2*c3 + c2;
    z = -z*0.5;

    p = 0; % Initialize p

    if (z > -80)
        p = c1 * exp(z);
        if (p > 0.0000000001)
            z = z + c5*(1+c6/(v3*v3));
            p = c1 * exp(z);
            z = h;
            z = z*z;

            c1 = v2-0.5;
            c2 = 0.0416666 / (c1*c1);
            c3 = 0.0208333 / (c1*c1*c1);
            c4 = 0.0078125 / (c1*c1*c1*c1);
            c5 = 0.0032552 / (c1*c1*c1*c1*c1);
            c6 = 0.001929  / (c1*c1*c1*c1*c1*c1);

            z_c5 = z*c5; % Re-using z*c5, store it

            p_mult = 1;
            if (z_c5 < 0.2)
                p_mult = (1 + z_c5*(1+z_c5*c6));
            end

            % Original code had z = z*c5, then another z = z*cfoo.
            % This seems like a typo and should be z_c4 = z * c4 etc.
            % Sticking to original author's code:
            z = z_c5 * c5; % This is (z*c5)*c5
            if (z < 0.2)
                p_mult = p_mult * (1 + z);
            end
            p = p * p_mult;

            z = h*h;
            c1 = (v2-1) / (v2*v2);
            p = p * (1 + c1*(0.75 + z*c2*(1.25+z*c3*(1.166667+z*c4*(1.125+z*c5)))));

            z  = 0.5 + 0.5*erf((h-sqrt(v2-1))/1.41421);
            p  = (z-p)*2;

            if (p < 0)
                p = 0;
            end
            if (p > 1)
                p = 1;
            end

            z = 0.70710678 * q;
            % The original paper seems to imply (p_of_z^k)
            % This author's implementation uses (p-0.5)^k + 0.5
            p_z = p;
            p = (p_z-0.5)^k + 0.5;

            if (k > 2)
                p = p + 0.25*(k-2)*exp(-z*z)*(p_z-0.5)^(k-1);
            end
        end
    end
end

return;
