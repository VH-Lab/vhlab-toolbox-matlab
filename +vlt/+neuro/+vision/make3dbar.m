function make3dbar;

clf;

pix_per_cm = 20;

im = zeros(256,256,3);

fudge = 0;

V = 57; % cm
d = 10/2;  % cm
wL = -1/4;  % cm
wR = 1/4;
e = 8;  % cm

 % capital indicates Left or Right edge of bar, lowercase is eye

D = [-10 -5 0 5 10]/2;
inc = 1;
for OFF=([25 75 100 125 150]+25),

d = D(inc);
inc = inc + 1;

[loR,roR]=vlt.neuro.vision.stereopoint(V,e,wR,d);
[loL,roL]=vlt.neuro.vision.stereopoint(V,e,wL,d);

loR = OFF+pix_per_cm*loR;
roR = OFF+pix_per_cm*roR;

loL = OFF+pix_per_cm*loL;
roL = OFF+pix_per_cm*roL;

 % right eye
im(:,round(roL:roR),3) = 1;
 % left eye
im(:,round(loL:loR),1) = 1;

end;

image(im);


