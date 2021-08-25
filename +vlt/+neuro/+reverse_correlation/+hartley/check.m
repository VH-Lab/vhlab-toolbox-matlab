function [out] = check(kx,ky)

img = vlt.neuro.reverse_correlation.hartley.hartley_image(kx,ky,500)/sqrt(2);
out = vlt.neuro.reverse_correlation.hartley.build(500,20,20);
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
