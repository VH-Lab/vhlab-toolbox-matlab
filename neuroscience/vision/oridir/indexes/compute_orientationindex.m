function oi = compute_orientationindex( angles, rates )

% COMPUTE_ORIENTATIONINDEX
%     DI = COMPUTE_ORIENTATIONINDEX( ANGLES, RATES )
%
%     Takes ANGLES in degrees
%
%     oi = (max + max_180 - max_90 - max_270)/(max)
%
%     no interpolation done
  
  [mx,ind]=max(rates);
  ang=angles(ind);
	
  j1 = findclosest(angles,mod(ang,360));
  j2 = findclosest(angles,mod(ang+180,360));
  j3 = findclosest(angles,mod(ang+90,360));
  j4 = findclosest(angles,mod(ang+270,360));
  m1 = rates(j1); 
  m2 = rates(j2);
  m3 = rates(j3); 
  m4 = rates(j4);
  di = (m1-m2)/(m1+0.0001); % direction index
  oi = (m1+m2-m3-m4)/(0.0001+(m1+m2)); % orientation

  di = round(100*di)/100;
  oi = round(100*oi)/100;
