function b = clip(a, clipvar)
% CLIP - Clip values between a low and a high limit
%
% B = CLIP(A, [LOW HIGH])
%
% Return a variable B, the same size as A, except that all values of
% A that are below LOW are set to the value LOW, and all values that
% are above HIGH are set to HIGH.
%
% See also: RECTIFY
%
% Example: 
%     b = CLIP([-Inf 0 1 2 3 Inf],[1 2])
%        % returns b = [1 1 1 2 2 2]
%

b = a;

b(find(a<clipvar(1))) = clipvar(1);
b(find(a>clipvar(2))) = clipvar(2);

