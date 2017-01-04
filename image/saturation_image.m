function im_out = saturation_image(im_in, varargin)
% SATURATION_IMAGE - Scale an image to allow a saturation plot
%
% IM_OUT = SATURATION_IMAGE(IM_IN, ...)
%
% Scales the image to be in the range 2 ... ColorMapSize-1 so that
% color map entries 1 and ColorMapSize can be used for saturation values.
%
% If HighSaturation is Inf, then, at the high edge, the image is scaled from
% its empirical max to ColorMapSize-1. Otherwise, the image is scaled from
% the value HighSaturation onto ColorMapSize-1.
%
% If LowSaturation is -Inf, then the image is scaled from its empirical min
% to 2. Otherwise, the image is scaled from LowSaturation to 2.
%
% Example:
%     myData = 40*membrane(1,25); % MathWorks logo
%     myImage = saturation_image(myData,'LowSaturation',0,'HighSaturation',20);
%     myColorMap = [ 0 0 0; jet(254); 1 1 1];
%     figure;
%     image(myImage);
%     colormap(myColorMap);
%
% This function also takes name/value pairs that modifies its behavior:
% Parameter (default)   | Description
% ---------------------------------------------------------------------
% ColorMapSize (256)    | Size of the colormap; also, value used for the high
%                       |   saturation index value
% HighSaturation (Inf)  | Value which, if exceeded, is set to be saturating
%                       |   on the high side
% LowSaturation (-Inf)  | Value, which, if not achieved, is set to be 
%                       |   saturating on the low side.
% LowSaturationValue (1)| Value used for the low saturation value
% NaNSaturation (1)     | Should NaN entries be set to Low (-1), High (1), or
%                       |   be left alone (0)  ?


ColorMapSize = 256;
HighSaturation = Inf;
LowSaturation = -Inf;
LowSaturationValue = 1;
NaNSaturation = 1;

assign(varargin{:});

HighIndexes = find(im_in>=HighSaturation);
LowIndexes = find(im_in<=LowSaturation);

if NaNSaturation~=0,
	NaNIndexes = find(isnan(im_in));
else, NaNIndexes = [];
end;

if isinf(HighSaturation) | isinf(LowSaturation),
	NumericalIndexes = find(isnumeric(im_in));
	high = max(im_in(NumericalIndexes));
	low  = min(im_in(NumericalIndexes));
else,
	high = HighSaturation;
	low  = LowSaturation;
end;

im_out = rescale(im_in,[low high],[2 ColorMapSize-1]);

im_out(HighIndexes) = ColorMapSize;
im_out(LowIndexes) = 1;
im_out(NaNIndexes) = ColorMapSize + (1-NaNSaturation)*(-1/2)*(ColorMapSize-1);


