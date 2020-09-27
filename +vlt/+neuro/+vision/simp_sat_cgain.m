function g = simp_sat_cgain(C,Cs)

% vlt.neuro.vision.simp_sat_cgain - Simple saturating contrast gain
%
%  G = vlt.neuro.vision.simp_sat_cgain(C, Cs)
%
%  Returns a simple contrast gain.  If contrast C is
%  less than Cs, then G = 1.  Otherwise, gain is
%  1-(C-Cs).  The gain falls off monotonically with
%  slope 1 after the point Cs.

r = C-2*(C-Cs).*((C-Cs)>0);
r(find(C==0))=1; C(find(C==0))=1;
g = r./C;
