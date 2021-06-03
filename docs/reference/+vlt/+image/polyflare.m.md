# vlt.image.polyflare

```
  POLYFLARE - Flare out a polygon by N units
 
    PNEW = POLYFLARE(P,N)
 
    This function enlarges a polygon by a fixed unit on all
    vertices. At each point, the polygon is stretched in both
    X and Y directions by N. The directions that causes the area to increase
    are chosen for the new polygon.
 
    Example:
         x = [63 186 54 190 63]';
         y = [60 60 209 204 60]';
         figure;
         plot(x,y,'o');
         polynew = polyflare([x y],0.5);
         hold on;
         plot(polynew(:,1),polynew(:,2),'go'); 
 
 
    See also: INSIDE, ROIPOLY, POLYAREA

```
