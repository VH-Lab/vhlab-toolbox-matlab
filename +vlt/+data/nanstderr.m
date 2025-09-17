function [se] = nanstderr(data)
% VLT.DATA.NANSTDERR - Calculate the standard error of the mean, ignoring NaN values
%
%   SE = vlt.data.nanstderr(DATA)
%
%   Computes the standard error of the mean for each column of the input
%   matrix DATA, while ignoring any NaN values.
%
%   The standard error is calculated as the standard deviation (ignoring NaNs)
%   divided by the square root of the number of non-NaN samples.
%
%   Example:
%       data = [1 2 NaN 4 5; 6 NaN 8 9 10]';
%       se = vlt.data.nanstderr(data);
%
%   See also: NANSTD, STDERR, SQRT, SUM, ISNAN
%

se = nanstd(data)./sqrt(sum(1-[isnan(data)]));
