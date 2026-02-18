function [mapping] = syncTriggers(T1, T2)
% SYNCTRIGGERS - Synchronize two trigger streams using linear regression
%
%  MAPPING = vlt.time.syncTriggers(T1, T2)
%
%  Finds the best linear mapping [shift scale] so that T2 is approximately
%  equal to shift + scale * T1.
%
%  T1 and T2 are vectors of trigger times from two devices that are active simultaneously.
%  They must have the same number of elements.
%
%  Inputs:
%    T1 - Vector of trigger times for device 1 (double)
%    T2 - Vector of trigger times for device 2 (double)
%
%  Outputs:
%    MAPPING - A 1x2 vector [shift scale]
%
%  Example:
%    T1 = [0 1 2];
%    T2 = [10 12 14]; % shift=10, scale=2
%    mapping = vlt.time.syncTriggers(T1, T2);
%    % mapping is [10 2]
%

arguments
    T1 double {mustBeVector}
    T2 double {mustBeVector}
end

if numel(T1) ~= numel(T2)
    error('vlt:time:syncTriggers:SizeMismatch', 'T1 and T2 must have the same number of elements.');
end

if isempty(T1)
    mapping = [NaN NaN];
    return;
end

N = numel(T1);

% Ensure column vectors for matrix calculations
T1 = T1(:);
T2 = T2(:);

if N < 100000
    % Use standard formula (centered for numerical stability)
    % beta1 = sum((x - mean(x)) .* (y - mean(y))) / sum((x - mean(x)).^2)
    % beta0 = mean(y) - beta1 * mean(x)

    mx = mean(T1);
    my = mean(T2);

    numerator = sum((T1 - mx) .* (T2 - my));
    denominator = sum((T1 - mx).^2);

    if denominator == 0
        mapping = [NaN NaN];
    else
        scale = numerator / denominator;
        shift = my - scale * mx;
        mapping = [shift scale];
    end
else
    % Use matrix division (backslash) for larger datasets
    % Model: T2 = shift + scale * T1
    % Form: T2 = [ones(N,1) T1] * [shift; scale]

    X = [ones(N,1) T1];

    % Check for rank deficiency/constant T1
    if all(T1 == T1(1))
         mapping = [NaN NaN];
    else
        % Solve X * b = T2
        b = X \ T2;
        mapping = b'; % [shift scale]
    end
end

end
