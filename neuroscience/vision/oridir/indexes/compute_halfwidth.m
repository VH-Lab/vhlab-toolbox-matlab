function [low,maxv,high]= compute_halfwidth( x, y )

% COMPUTE_LOWHALFMAX
%     [LOW,MAX,HIGH] = COMPUTE_HALFWIDTH( X, Y )
%
%     interpolates function by linearly (splines goes strange for small points)
%     and returns MAX, where x position where function attains its maximum value
%     LOW < MAX,  where function attains half its maximum
%     HIGH > MAX, where function attains half its maximum
%     returns NAN for LOW or/and HIGH, when function does not come below the point
%     
%     note: ugly,slow and crude routine,    consider taking log x first

  % alexander notes: ugly, slow, and crude; steve says he's too hard on himself, it's been super useful for at least 4 studies

if length(x)<500
  step=(x(end)-x(1))/500;  % not that many steps, consider taking log first
  finex=(x(1):step:x(end));
else
  finex=x
end

intfunction=interp1(x,y,finex,'linear');


[maxvalue,maxv]=max(intfunction);
halfheight=maxvalue/2;

if( min( intfunction(1:maxv)-halfheight)>0 );
  % never below halfline
  low =nan;
else
  [low,lowvalue]=findclosest(intfunction(1:maxv),halfheight);
  low=finex(low);
end

if( min( intfunction(maxv:end)-halfheight)>0 );
  % never below halfline
  high =nan;
else
  [high,highvalue]=findclosest(intfunction(maxv:end),halfheight);
  high=finex(high+maxv-1);
end

maxv=finex(maxv);
