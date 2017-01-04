function rgb_out = invertcolors(rgb_in, c1, c2)
% Invert colors in an RGB image **UNTESTED**
%
%   RGB_OUT = INVERTCOLORS(RGB_IN)
%
%   Inverts an RGB image RGB_IN so that black becomes white and
%   white becomes black.  The output is returned in RGB_OUT.
%
%   RGB_OUT = INVERTCOLORS(RGB_IN, C1, C2)
%
%   One can specify the axis of reversal by providing 2 colors
%   and the midpoint.  For example, with the default conversion,
%   C1 = [0 0 0] and C2 = [1 1 1].
%
%
%   **COMPLETELY UNTESTED; TEST AND FIX BEFORE USE**
%
%   ** BUG, fails color [0 0 1] start development there **

C1 = [0 0 0];
C2 = [1 1 1];

if nargin>1, C1 = c1; end;
if nargin>2, C2 = c2; end;

if strcmp(class(rgb_in),'uint8'),
	rgb_in = double(rgb_in)/255;
end;

RGB_reshape = reshape(rgb_in,size(rgb_in,1)*size(rgb_in,2),size(rgb_in,3));

midpoint = (C1 + C2) / 2;

 % shift around midpoint
RGB_meanshift=RGB_reshape-repmat(midpoint,size(rgb_in,1)*size(rgb_in,2),1);
RGB_overlap = zeros(size(RGB_meanshift));

VectorDiff = repmat(C1-C2,size(rgb_in,1)*size(rgb_in,2),1);

RGB_overlap = RGB_meanshift.*VectorDiff;

% normalize
RGB_overlap = RGB_overlap / (2*(C1-midpoint)*(C1-midpoint)');
min(RGB_overlap(:)),
max(RGB_overlap(:)),

RGB_out=RGB_shift-RGB_overlap.*repmat(C1-C2,size(rgb_in,1)*size(rgb_in,2),1);

RGB_out = RGB_out + repmat(midpoint,size(rgb_in,1)*size(rgb_in,2),1);

rgb_out=reshape(RGB_out,size(rgb_in,1),size(rgb_in,2),size(rgb_in,3));

