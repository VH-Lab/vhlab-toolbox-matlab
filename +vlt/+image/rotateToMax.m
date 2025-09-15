function results = rotateToMax(image, mask, pointsOfInterest, windowSize, options)
% ROTATETOMAX - Finds the direction of maximum signal in local regions and rotates them.
%
%   RESULTS = vlt.image.rotateToMax(IMAGE, MASK, POINTSOFINTEREST, WINDOWSIZE, ...)
%
%   For each point of interest, this function extracts a square local region
%   (thumbnail) and analyzes the signal within a series of angular wedges
%   centered on the point. It identifies the direction with the maximum mean
%   signal and rotates the thumbnail so this direction points "up" (0 degrees).
%
%   This is useful for analyzing and normalizing anisotropic patterns around
%   specific features in an image.
%
%   Inputs:
%     image            - A 2D data matrix.
%     mask             - A logical matrix of the same size as IMAGE. True values
%                        indicate valid pixels to be included in the analysis.
%     pointsOfInterest - An Nx2 matrix of [x, y] coordinates for the center
%                        of each region to be analyzed.
%     windowSize       - The approximate size of the square thumbnail region
%                        in pixels. The actual size will be rounded to the
%                        nearest odd integer to ensure a perfect center.
%
%   Name-Value Pairs:
%     'numDirections'    - The number of angular wedges to examine around each
%                          point. (Default: 18)
%     'wedgeAngleWidth'  - The angular width of each wedge in degrees.
%                          (Default: 30)
%
%   Outputs:
%     RESULTS - A structure array with one element for each point of interest,
%               containing the following fields:
%       .pointOfInterest   - The [x y] coordinate of the point.
%       .rotatedImage      - The thumbnail image, rotated so the maximum
%                            signal direction is at 0 degrees (up).
%       .wedgeDirections   - The compass directions (0-360 deg) of each wedge.
%       .wedgeSignalValues - The mean signal value within each wedge.
%       .maximumDirection  - The compass direction with the maximum signal.
%

% --- Input Validation and Defaults ---
arguments
    image (:,:) {mustBeNumeric}
    mask (:,:) {mustBeLogical, mustBeEqualSize(image, mask)}
    pointsOfInterest (:,2) {mustBeNumeric}
    windowSize (1,1) {mustBeNumeric, mustBePositive}
    options.numDirections (1,1) {mustBeInteger, mustBePositive} = 18
    options.wedgeAngleWidth (1,1) {mustBeNumeric, mustBePositive} = 30
end

% Pre-allocate the results structure
results = repmat(struct(...
    'pointOfInterest', [], ...
    'rotatedImage', [], ...
    'wedgeDirections', [], ...
    'wedgeSignalValues', [], ...
    'maximumDirection', []), ...
    size(pointsOfInterest, 1), 1);

% Define the compass directions for the wedges
wedgeDirections_compass = linspace(0, 360, options.numDirections + 1);
wedgeDirections_compass = wedgeDirections_compass(1:end-1);

% Define the half-width of the analysis window, ensuring it's an integer
halfWin = floor(windowSize / 2);
win_dim = 2 * halfWin + 1;

% Create a coordinate grid for the thumbnail, centered at (0,0)
[X, Y] = meshgrid(-halfWin:halfWin, -halfWin:halfWin);
% Calculate the angle of each pixel in Cartesian coordinates
% (degrees, CCW from +x axis). Note the -Y to account for image coordinates.
Theta_cartesian = atan2d(-Y, X);

% --- Main loop over each point of interest ---
for i = 1:size(pointsOfInterest, 1)
    poi = pointsOfInterest(i, :);
    
    % --- 1. Extract the thumbnail region ---
    % Define the rectangular region of interest (ROI)
    x_start = round(poi(1)) - halfWin;
    x_end = round(poi(1)) + halfWin;
    y_start = round(poi(2)) - halfWin;
    y_end = round(poi(2)) + halfWin;
    
    % Create a blank thumbnail to handle edge cases
    thumb_data = NaN(win_dim, win_dim);
    
    % Define the intersection of the ROI and the actual image dimensions
    img_x_range = max(1, x_start):min(size(image, 2), x_end);
    img_y_range = max(1, y_start):min(size(image, 1), y_end);
    
    % Define where this data will go in our thumbnail
    thumb_x_range = img_x_range - x_start + 1;
    thumb_y_range = img_y_range - y_start + 1;
    
    % Extract the data and mask
    thumb_data(thumb_y_range, thumb_x_range) = image(img_y_range, img_x_range);
    thumb_mask = false(win_dim, win_dim);
    thumb_mask(thumb_y_range, thumb_x_range) = mask(img_y_range, img_x_range);
    
    % Apply the mask to the thumbnail data
    thumb_data(~thumb_mask) = NaN;
    
    % --- 2. Calculate signal within each wedge ---
    wedgeSignalValues = zeros(1, options.numDirections);
    for j = 1:options.numDirections
        center_angle_compass = wedgeDirections_compass(j);
        
        % Convert from compass (0=up, CW) to Cartesian (0=right, CCW)
        center_angle_cartesian = mod(450 - center_angle_compass, 360);
        % Normalize to [-180, 180] to match atan2d output range
        if center_angle_cartesian > 180
            center_angle_cartesian = center_angle_cartesian - 360;
        end
        
        % Find the angular difference for every pixel in the grid
        delta_theta = Theta_cartesian - center_angle_cartesian;
        % Wrap the difference to the [-180, 180] interval
        delta_theta(delta_theta > 180) = delta_theta(delta_theta > 180) - 360;
        delta_theta(delta_theta < -180) = delta_theta(delta_theta < -180) + 360;
        
        % Create a logical mask for pixels inside this wedge
        wedge_mask = abs(delta_theta) <= options.wedgeAngleWidth / 2;
        
        % Calculate the mean of the valid, non-NaN pixels within the wedge
        wedgeSignalValues(j) = mean(thumb_data(wedge_mask), 'omitnan');
    end
    
    % --- 3. Find max direction and rotate image ---
    [~, max_idx] = max(wedgeSignalValues);
    maximumDirection = wedgeDirections_compass(max_idx);
    
    % The rotation angle needed to make the max direction point up (0 degrees)
    rotation_angle = -maximumDirection;
    
    % Rotate the original thumbnail, filling empty space with NaN
    rotatedImage = imrotate(thumb_data, rotation_angle, 'bilinear', 'crop');
    
    % --- 4. Store results in the output structure ---
    results(i).pointOfInterest = poi;
    results(i).rotatedImage = rotatedImage;
    results(i).wedgeDirections = wedgeDirections_compass;
    results(i).wedgeSignalValues = wedgeSignalValues;
    results(i).maximumDirection = maximumDirection;
end

end

function mustBeEqualSize(a, b)
    if ~isequal(size(a), size(b))
        eid = 'Size:notEqual';
        msg = 'Size of inputs must be equal.';
        throwAsCaller(MException(eid, msg));
    end
end

