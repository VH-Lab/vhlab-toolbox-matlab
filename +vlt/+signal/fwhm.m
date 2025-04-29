function [peakLocation, fWidth, low_cutoff, high_cutoff, peakValue] = fwhm(X, Y)
%vlt.signal.fwhm Computes peak location (X-value) and full width at half maximum (FWHM).
%
%   [peakLocation, fWidth, low_cutoff, high_cutoff, peakValue] = vlt.signal.fwhm(X, Y)
%
%   Examines the data vector Y with corresponding X-axis labels X (e.g., time,
%   frequency) to find the location of the peak value on the X-axis and the
%   full width at half maximum (FWHM).
%
%   Inputs:
%     X           (Nx1 double) - Column vector of X-axis values.
%     Y           (Nx1 double) - Column vector of corresponding Y-axis data values.
%
%   Outputs:
%     peakLocation (double)     - The X value where the maximum value of Y occurs.
%     fWidth      (double)     - The full width at half maximum height (high_cutoff - low_cutoff).
%                                Returns Inf if the data does not drop below half height
%                                on either side of the peak.
%     low_cutoff  (double)     - The interpolated X value on the falling edge (X < peakLocation)
%                                where Y crosses 0.5 * peakValue. Returns -Inf if Y
%                                never drops below this threshold before the peak.
%     high_cutoff (double)     - The interpolated X value on the rising edge (X > peakLocation)
%                                where Y crosses 0.5 * peakValue. Returns Inf if Y
%                                never drops below this threshold after the peak.
%     peakValue   (double)     - The maximum value found in Y (optional output).
%
%   Details:
%     - Finds the maximum value (peakValue) and its index (peakIndex) in Y.
%     - Determines the X-axis location of the peak (peakLocation = X(peakIndex)).
%     - Calculates the half-height threshold (0.5 * peakValue).
%     - Searches backwards from the peak to find the first point below the threshold.
%     - Searches forwards from the peak to find the first point below the threshold.
%     - Linearly interpolates between the points immediately above and below the
%       threshold on both sides to find the exact X cutoff values.
%
%   See also: MAX, FIND, INTERP1

% --- Input Validation ---
arguments
    X (:,1) double % Ensure X is a column vector of doubles
    Y (:,1) double % Ensure Y is a column vector of doubles
end

% Additional validation (optional but good practice)
if numel(X) ~= numel(Y)
    error('vlt:signal:fwhm:InputSizeMismatch', 'X and Y must have the same number of elements.');
end
if numel(X) < 2
    error('vlt:signal:fwhm:NotEnoughPoints', 'Input vectors must have at least two data points for interpolation.');
end
% --- End Input Validation ---

% --- Find Peak Value, Index, Location and Half Height ---
[peakValue, peakIndex] = max(Y);
peakLocation = X(peakIndex); % Get the X value at the peak index
halfHeight = 0.5 * peakValue;
n_points = numel(Y);

% --- Find Low Cutoff (Searching backwards from peak) ---
low_cutoff = -Inf; % Default if threshold not crossed

if peakIndex > 1 % Can only search backwards if peak is not the first point
    % Find indices *before* the peak where Y is below halfHeight
    indices_below_low = find(Y(1:peakIndex-1) < halfHeight);

    if ~isempty(indices_below_low)
        % The last index before the peak that is below threshold
        idx_low = indices_below_low(end);

        % Points for interpolation are idx_low and idx_low + 1
        % (idx_low + 1 is guaranteed to be <= peakIndex and >= halfHeight)
        y1_low = Y(idx_low);     % Point below threshold
        x1_low = X(idx_low);
        y2_low = Y(idx_low + 1); % Point above or at threshold
        x2_low = X(idx_low + 1);

        % Linear Interpolation: Solve for x where y = halfHeight
        % x = x1 + (y - y1) * (x2 - x1) / (y2 - y1)
        if abs(y2_low - y1_low) < eps % Avoid division by zero/near-zero
            low_cutoff = x1_low; % Take the lower X value if Y values are identical
        else
            low_cutoff = x1_low + (halfHeight - y1_low) * (x2_low - x1_low) / (y2_low - y1_low);
        end
    end
    % Else: No points below threshold found before the peak, low_cutoff remains -Inf
end
% Else: peakIndex is 1, cannot have a low cutoff, remains -Inf

% --- Find High Cutoff (Searching forwards from peak) ---
high_cutoff = Inf; % Default if threshold not crossed

if peakIndex < n_points % Can only search forwards if peak is not the last point
    % Find indices *after* the peak where Y is below halfHeight
    % Need to adjust index relative to the subset Y(peakIndex+1:end)
    indices_below_high_rel = find(Y(peakIndex+1:end) < halfHeight);

    if ~isempty(indices_below_high_rel)
        % The first index *relative* to the start of the sub-vector
        idx_high_rel = indices_below_high_rel(1);
        % The absolute index in the original Y vector
        idx_high = peakIndex + idx_high_rel;

        % Points for interpolation are idx_high - 1 and idx_high
        % (idx_high - 1 is guaranteed to be >= peakIndex and >= halfHeight)
        y1_high = Y(idx_high - 1); % Point above or at threshold
        x1_high = X(idx_high - 1);
        y2_high = Y(idx_high);     % Point below threshold
        x2_high = X(idx_high);

        % Linear Interpolation: Solve for x where y = halfHeight
        % x = x1 + (y - y1) * (x2 - x1) / (y2 - y1)
         if abs(y2_high - y1_high) < eps % Avoid division by zero/near-zero
             high_cutoff = x1_high; % Take the lower X value if Y values are identical
         else
            high_cutoff = x1_high + (halfHeight - y1_high) * (x2_high - x1_high) / (y2_high - y1_high);
         end
    end
    % Else: No points below threshold found after the peak, high_cutoff remains Inf
end
% Else: peakIndex is n_points, cannot have a high cutoff, remains Inf

% --- Calculate Full Width at Half Maximum ---
fWidth = high_cutoff - low_cutoff;
% Note: If low_cutoff is -Inf or high_cutoff is Inf, fWidth will be Inf.

% --- Assign peakValue as optional output ---
% The primary outputs are peakLocation, fWidth, low_cutoff, high_cutoff.
% peakValue is assigned here based on the earlier max() call.
% If the user calls the function requesting fewer than 5 outputs,
% MATLAB will assign them in order.

end

