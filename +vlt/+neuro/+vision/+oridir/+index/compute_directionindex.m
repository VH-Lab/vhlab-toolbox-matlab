function di = compute_directionindex( angles, rates )

% vlt.neuro.vision.oridir.index.compute_directionindex
%     DI = vlt.neuro.vision.oridir.index.compute_directionindex( ANGLES, RATES )
%
%     Takes ANGLES in degrees
%
%     di = (maxrate - rate(stimulus in oppositedirection))/maxrate
%            di == 1 means maximally selective
%            di == 0 means not selective
%
  
  [maxv,ind]=max(rates);
  ang=angles(ind);
	
  j1 = vlt.data.findclosest(angles,mod(ang,360));
  j2 = vlt.data.findclosest(angles,mod(ang+180,360));
  j3 = vlt.data.findclosest(angles,mod(ang+90,360));
  j4 = vlt.data.findclosest(angles,mod(ang+270,360));
  m1 = rates(j1); 
  m2 = rates(j2);
  m3 = rates(j3); 
  m4 = rates(j4);
  di = (m1-m2)/(m1+0.0001); % direction index
  oi = (m1+m2-m3-m4)/(0.0001+(m1+m2)); % orientation

  di=round(100*di)/100;
  oi=round(100*oi)/100;
