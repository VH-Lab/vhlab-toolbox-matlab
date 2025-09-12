function C = corrcoef(image1, image2, mask1, mask2, N)
% CORRCOEF - Computes a 2D spatial cross-correlation between two images.
%
%   C = vlt.image.corrcoef(IMAGE1, IMAGE2, MASK1, MASK2, N)
%
%   Calculates the Pearson correlation coefficient between two images (IMAGE1
%   and IMAGE2) at various spatial lags or shifts. The correlation is
%   computed over a square range of shifts from -N to +N pixels in both the
%   x and y dimensions.
%
%   Inputs:
%     IMAGE1  - The first input image (an MxP matrix).
%     IMAGE2  - The second input image (must be the same size as IMAGE1).
%     MASK1   - A logical mask for IMAGE1. Pixels are included in the
%               correlation only if the corresponding mask value is true.
%     MASK2   - A logical mask for IMAGE2.
%     N       - An integer defining the half-width of the shift range. The
%               total range of shifts will be from -N to +N, resulting in a
%               (2*N+1) x (2*N+1) output matrix.
%
%   Outputs:
%     C       - A (2*N+1)x(2*N+1) matrix of correlation coefficients.
%               - The center element, C(N+1, N+1), is the correlation with
%                 zero shift.
%               - An element C(y+N+1, x+N+1) corresponds to the correlation
%                 between IMAGE1 and a version of IMAGE2 shifted by 'y' pixels
%                 vertically and 'x' pixels horizontally.
%
%   The correlation at each shift is calculated only using the pixels that
%   are valid in both images' masks after the shift is applied.
%

% --- Input Validation ---
if ~isequal(size(image1), size(image2)) || ...
   ~isequal(size(image1), size(mask1)) || ...
   ~isequal(size(image1), size(mask2))
    error('All input images and masks must be the same size.');
end

if ~(isnumeric(N) && isscalar(N) && N >= 0 && floor(N) == N)
    error('N must be a non-negative integer scalar.');
end

% --- Initialization ---
output_size = 2 * N + 1;
C = NaN(output_size, output_size); % Initialize with NaNs
[rows, cols] = size(image1);

% --- Loop through half of the pixel shifts, leveraging symmetry ---
for y_shift = 0:N
    % Define the range for x_shift to avoid redundant calculations
    if y_shift == 0
        x_range = 0:N; % For the central row, only compute half
    else
        x_range = -N:N; % For other rows, compute the full width
    end

    for x_shift = x_range
        % --- Determine overlapping regions for the current shift ---
        % This logic finds the valid index ranges for both images after one
        % is hypothetically shifted relative to the other.

        y1_start = max(1, 1 - y_shift);
        y1_end = min(rows, rows - y_shift);
        x1_start = max(1, 1 - x_shift);
        x1_end = min(cols, cols - x_shift);

        y2_start = max(1, 1 + y_shift);
        y2_end = min(rows, rows + y_shift);
        x2_start = max(1, 1 + x_shift);
        x2_end = min(cols, cols + x_shift);

        % --- Extract the overlapping data and masks ---
        sub_img1 = image1(y1_start:y1_end, x1_start:x1_end);
        sub_img2 = image2(y2_start:y2_end, x2_start:x2_end);
        sub_mask1 = mask1(y1_start:y1_end, x1_start:x1_end);
        sub_mask2 = mask2(y2_start:y2_end, x2_start:x2_end);

        % --- Combine masks and vectorize data ---
        % The final mask includes only pixels that are valid in both masks
        % and are not NaN in either sub-image.
        combined_mask = sub_mask1 & sub_mask2 & ~isnan(sub_img1) & ~isnan(sub_img2);

        vec1 = sub_img1(combined_mask);
        vec2 = sub_img2(combined_mask);

        % --- Calculate and store the correlation coefficient ---
        % Ensure there are enough data points to compute a correlation
        if numel(vec1) >= 2
            R = corrcoef(vec1, vec2);
            val = R(1, 2);

            % Store the result and its symmetric counterpart
            C(y_shift + N + 1, x_shift + N + 1) = val;
            C(-y_shift + N + 1, -x_shift + N + 1) = val;
        end
    end % x_shift loop
end % y_shift loop

end

