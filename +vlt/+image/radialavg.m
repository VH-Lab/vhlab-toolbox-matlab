function [dx, Cmean, Cstddev, Cstderr] = radialavg(C)
% RADIALAVG - Computes the 1D radial average of a 2D matrix.
%
%   [DX, CMEAN, CSTDDEV, CSTDERR] = vlt.image.radialavg(C)
%
%   Calculates the 1D radial average profile of a 2D matrix, such as a
%   correlation map from vlt.image.corrcoef. The function computes the mean,
%   standard deviation, and standard error of all values at the same radial
%   distance from the center of the matrix.
%
%   Inputs:
%     C - A 2D matrix (e.g., a correlation map). It is assumed that the
%         (0,0) point of the data is at the center of the matrix.
%
%   Outputs:
%     dx      - A 1D vector of the radial distances from the center in pixels.
%     Cmean   - A 1D vector of the mean value of C for each distance in dx.
%     Cstddev - A 1D vector of the standard deviation of C for each distance.
%     Cstderr - A 1D vector of the standard error of the mean of C for each
%               distance.
%
%   Example:
%     % First, generate a sample correlation map
%     img = rand(100);
%     img_shifted = circshift(img, [5 10]);
%     mask = true(100);
%     C = vlt.image.corrcoef(img, img_shifted, mask, mask, 20);
%
%     % Now, compute and plot the radial average
%     [dx, Cmean, ~, Cstderr] = vlt.image.radialavg(C);
%     figure;
%     errorbar(dx, Cmean, Cstderr);
%     xlabel('Distance from center (pixels)');
%     ylabel('Average Correlation Coefficient');
%     title('Radial Average of Correlation Map');
%

% --- Input Validation ---
arguments
    C (:,:) {mustBeNumeric}
end

% --- Prepare for Radial Averaging ---
[rows, cols] = size(C);
center_y = floor(rows / 2) + 1;
center_x = floor(cols / 2) + 1;

% Create coordinate grids
[X, Y] = meshgrid(1:cols, 1:rows);
% Calculate the radial distance of each pixel from the center
radial_dist = sqrt((X - center_x).^2 + (Y - center_y).^2);

% --- Group and Calculate Statistics ---
% Group the data by integer radial distance.
% We ignore any NaN values in the correlation map itself.
valid_indices = ~isnan(C(:));
radial_bins = floor(radial_dist(valid_indices));
C_values = C(valid_indices);

% Use findgroups and splitapply for efficient computation
[G, dx] = findgroups(radial_bins);
Cmean = splitapply(@mean, C_values, G);
Cstddev = splitapply(@std, C_values, G);
counts = splitapply(@numel, C_values, G);
Cstderr = Cstddev ./ sqrt(counts);

% Ensure dx is a column vector for consistency
dx = dx(:);

end
