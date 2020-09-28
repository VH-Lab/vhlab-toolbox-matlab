function tuningwidth = compute_tuningwidth( angles, rates )

% vlt.neuro.vision.oridir.index.compute_tuningwidth
%     TUNINGWIDTH = vlt.neuro.vision.oridir.index.compute_tuningwidth( ANGLES, RATES )
%
%     Takes ANGLES in degrees
%
%     linearly interpolates rates
%     and returns the half of the distance
%     between the two points sandwiching the maximum
%     where the response is 1/sqrt(2) of the maximum rate.
%     returns 90, when function does not come below the point
%
% See Rinach et al. J.Neurosci. 2002 22:5639-5651

angles = [angles 360+angles 720];
rates = [rates rates rates(1)];
fineangles=(0:1:720);

intrates=interp1(angles,rates,fineangles,'linear');

[maxrate,pref]=max(intrates(181:540));
pref=pref+179;
halfheight=maxrate/sqrt(2);

if( min(intrates-halfheight)>0 );
  % never below halfline
  tuningwidth = 90;
else
     [left,leftvalue]=vlt.data.findclosest(intrates(pref-90:pref),halfheight);
     left=left+pref-90-2;
     [right,rightvalue]=vlt.data.findclosest(intrates(pref:pref+90),halfheight);
     right=right+pref-2;
     tuningwidth=(right-left)/2;
     if(tuningwidth>90)
       tuningwidth=90;
     end
end


