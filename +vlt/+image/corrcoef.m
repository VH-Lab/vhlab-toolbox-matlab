function C = corrcoef(image1, image2, mask1, mask2, N)
% CORRCOEF - Computes a 2D spatial cross-correlation coefficient map.
%
%   C = vlt.image.corrcoef(IMAGE1, IMAGE2, MASK1, MASK2, N)
%
%   Calculates the 2D cross-correlation coefficient between two images for a
%   range of spatial shifts up to N pixels in x and y. The correlation is
%   only computed over pixels that are valid in both provided masks.
%
%   The function leverages the symmetry of the correlation coefficient,
%   C(dy, dx) = C(-dy, -dx), to reduce computations by about half.
%
%   Inputs:
%     IMAGE1 - The first 2D data matrix.
%     IMAGE2 - The second 2D data matrix, must be the same size as IMAGE1.
%     MASK1  - A logical matrix of the same size as IMAGE1. True values
%              indicate valid pixels to be included in the correlation.
%     MASK2  - A logical matrix for IMAGE2, same size and meaning as MASK1.
%     N      - A scalar integer specifying the maximum shift in pixels for
%              the correlation calculation. The output will be (2N+1)x(2N+1).
%
%   Outputs:
%     C      - A (2N+1)x(2N+1) matrix containing the correlation coefficients.
%              The center of the matrix (C(N+1, N+1)) corresponds to a
%              zero-pixel shift.
%
%   Example:
%     img = rand(100);
%     img_shifted = circshift(img, [5 10]);
%     mask = true(100);
%     C = vlt.image.corrcoef(img, img_shifted, mask, mask, 20);
%     figure;
%     imagesc(-20:20, -20:20, C);
%     colorbar;
%     title('Spatial Cross-Correlation');
%     xlabel('X Shift (pixels)'); ylabel('Y Shift (pixels)');
%

% --- Input Validation ---
arguments
    image1 (:,:) {mustBeNumeric}
    image2 (:,:) {mustBeNumeric, mustBeEqualSize(image1, image2)}
    mask1 (:,:) logical {mustBeEqualSize(mask1, image1)}
    mask2 (:,:) logical {mustBeEqualSize(mask2, image1)}
    N (1,1) {mustBeInteger, mustBeNonnegative}
end

% --- Initialization ---
C = NaN(2 * N + 1, 2 * N + 1);
[rows, cols] = size(image1);

% --- Correlation Calculation ---
% Loop through half of the shifts, including the zero shift.
for y_shift = 0:N
    for x_shift = -N:N
        % Skip redundant calculation for the first row
        if y_shift == 0 && x_shift < 0
            continue;
        end

        % Define the overlapping regions for both images based on the shift
        y_range1 = max(1, 1 - y_shift):min(rows, rows - y_shift);
        x_range1 = max(1, 1 - x_shift):min(cols, cols - x_shift);

        y_range2 = max(1, 1 + y_shift):min(rows, rows + y_shift);
        x_range2 = max(1, 1 + x_shift):min(cols, cols + x_shift);

        % Extract the data and mask for the overlapping regions
        sub_img1 = image1(y_range1, x_range1);
        sub_img2 = image2(y_range2, x_range2);
        sub_mask1 = mask1(y_range1, x_range1);
        sub_mask2 = mask2(y_range2, x_range2);

        % Create a combined mask of valid pixels for the current shift
        % A pixel is valid if it's true in both masks and not NaN in either image
        combined_mask = sub_mask1 & sub_mask2 & ~isnan(sub_img1) & ~isnan(sub_img2);

        % If there are enough overlapping valid pixels, compute the correlation
        if sum(combined_mask, 'all') > 1
            v1 = sub_img1(combined_mask);
            v2 = sub_img2(combined_mask);
            R = corrcoef(v1, v2);
            C(y_shift + N + 1, x_shift + N + 1) = R(1, 2);
        else
            C(y_shift + N + 1, x_shift + N + 1) = NaN;
        end

        % Use symmetry to fill in the other half of the correlation matrix
        if y_shift ~= 0 || x_shift ~= 0
             C(-y_shift + N + 1, -x_shift + N + 1) = C(y_shift + N + 1, x_shift + N + 1);
        end
    end
end

end

function mustBeEqualSize(a, b)
    if ~isequal(size(a), size(b))
        eid = 'Size:notEqual';
        msg = 'Size of inputs must be equal.';
        throwAsCaller(MException(eid, msg));
    end
end

function mustBeInteger(a)
    if mod(a, 1) ~= 0
        eid = 'Type:notInteger';
        msg = 'Input must be an integer.';
        throwAsCaller(MException(eid, msg));
    end
end