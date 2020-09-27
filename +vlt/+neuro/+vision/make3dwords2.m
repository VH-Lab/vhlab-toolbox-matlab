

clf;

axes;

set(gca,'color',[0 0 0]);

V=57;  % viewing distance from eye to object
dE = 8; % distance between eyes in cm
pix_per_cm = 20;
Vo = pix_per_cm*sqrt((dE/2).^2+V.^2);



%text(0,250,'3D text','color',[0.8 0 0]);
%text(0,250,'3D text','color',[0 0.0 0.8]);


inc = 0;
for w=-1:0.1:1,
	dX = 0*w*3; % cm offset
	dD = 10*w; % cm more distant
	[lo,ro]=vlt.neuro.vision.stereopoint(V,dE,dX,dD),
	
	r = 1*50*(rand-0.5);
	text(r+pix_per_cm*lo,inc,'3D text','color',[0.8 0 0]);
	text(r+pix_per_cm*ro,inc,'3D text','color',[0 0.0 0.8]);

	inc = inc+20;
end;

axis([-100 100 -100 500]);
