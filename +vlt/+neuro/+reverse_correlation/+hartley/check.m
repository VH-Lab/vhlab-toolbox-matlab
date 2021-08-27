function [out] = check(kx,ky, M)
% CHECK - check a rapid procedure for drawing Hartley stimli
%
% OUT = vlt.neuro.reverse_correlation.hartley.check(KX, KY, M)
%
% Draws a Hartley stimulus where the stimulus has MxM pixels,
% for Hartley numbers KX and KY. Also shows accuracy of the 
% rapid procedure reconstruction and the full Hartley calculation.
%
% The complete workspace variables used to build the stimulus and
% draw the stimulus are returned in OUT, for diagnostic purposes.
%
% See also: vlt.neuro.reverse_correlation.hartley.build, vlt.neuro.reverse_correlation.hartley.draw
%  
% Example:
%    out = vlt.neuro.reverse_correlation.hartley.check(5,15,500);
% 
% 

img = vlt.neuro.reverse_correlation.hartley.hartley_image(kx,ky,M)/sqrt(2);
out = vlt.neuro.reverse_correlation.hartley.build(M,floor(M/2),floor(M/2));
[im,out2] = vlt.neuro.reverse_correlation.hartley.draw(out,kx,ky);

figure;

subplot(2,2,1);
plot(img(:,1),'b');
hold on;
plot(im(:,1),'g--');
title('Y axis');

subplot(2,2,2);
plot(diag(img),'b');
hold on;
plot(diag(im),'g--');
title('diag');

subplot(2,2,3);
plot(img(1,:),'b');
hold on;
plot(im(1,:),'g--');
title('X axis');

out = var2struct('out','out2','img','im');

imagedisplay(img);
ax1 = gca;
title('Raw');

imagedisplay(im);
ax2 = gca;
title('Rotated and computed')

linkaxes([ax1 ax2]);
