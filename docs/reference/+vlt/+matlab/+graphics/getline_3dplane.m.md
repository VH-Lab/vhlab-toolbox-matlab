# vlt.matlab.graphics.getline_3dplane

 GETLINE_3DPLANE Select polyline with mouse.
    [X,Y,Z] = vlt.matlab.graphics.getline_3dplane(FIG) lets you select a polyline in the
    current axes of figure FIG using the mouse.  Coordinates of
    the polyline are returned in X and Y and Z.  Use normal button
    clicks to add points to the polyline.  A shift-, right-, or
    double-click adds a final point and ends the polyline
    selection.  Pressing RETURN or ENTER ends the polyline
    selection without adding a final point.  Pressing BACKSPACE
    or DELETE removes the previously selected point from the
    polyline.
 
    [X,Y,Z] = vlt.matlab.graphics.getline_3dplane(AX) lets you select a polyline in the axes
    specified by the handle AX.
 
    [X,Y,Z] = vlt.matlab.graphics.getline_3dplane is the same as [X,Y] = vlt.matlab.graphics.getline_3dplane(GCF).
 
    [X,Y,Z] = vlt.matlab.graphics.getline_3dplane(...,'closed') animates and returns a closed
    polygon.
 
    Example
    --------
        imshow('moon.tif')
        [x,y] = vlt.matlab.graphics.getline_3dplane 
 
    See also GETLINE, GETRECT, GETPTS.
 
    Modified from GETLINE by SDV
