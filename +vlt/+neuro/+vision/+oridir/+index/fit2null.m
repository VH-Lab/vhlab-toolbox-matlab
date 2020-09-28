function null = fit2null(R)
% FIT2NULL - calculate the null (anti-preferred) response from a fit to direction
%
%  NULL=vlt.neuro.vision.oridir.index.fit2null(RESPONSE)
%
%  Given the RESPONSE of a double gaussian fit, return the response 180 degrees
%  away from the location with the maximum response.  This is the null
%  response or the response in the anti-preferred direction.
%
%  RESPONSE is a 360x2 vector of responses. The first row indicates the 
%  angles of the fit, and the second row indicates the responses.
%
%  For backwards compatibility, if RESPONSE is a 360x1 vector, a new first
%  row is added equal to 0:359.
%
%  See also: vlt.neuro.vision.oridir.index.fit2pref, vlt.neuro.vision.oridir.index.fit2orth

if size(R,1)==1,
    R = [0:359; R];
end;

[mx,Ot] = max(R(2,:));
OtPi = vlt.data.findclosest(R(1,:),Ot);
OtNi = vlt.data.findclosest(R(1,:),mod(Ot+180,360));
OtO1i = vlt.data.findclosest(R(1,:),mod(Ot+90,360));
OtO2i = vlt.data.findclosest(R(1,:),mod(Ot-90,360));
null = (R(2,OtNi));
