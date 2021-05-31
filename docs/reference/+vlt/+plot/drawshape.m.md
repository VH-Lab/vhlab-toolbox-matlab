# vlt.plot.drawshape

  vlt.plot.drawshape -- Draw a simple shape in an image or as a vector plot
 
 
   H = vlt.plot.drawshape(SHAPE)
 
      Draws a shape using plots in current axes (vector mode).
   H is a list of handles to the plots.
 
   INDS = vlt.plot.drawshape(SHAPE, MESHX, MESHY)
 
      Returns a set of indexes that will make SHAPE on a bitmap with
   coordinate system MESHX x MESHY.  (See 'help mesh'.)
 
     SHAPE should be a struct with fields that vary according to the shape
   requested.  Each shape should have a field 'shape' that describes the shape,
   and appropriate fields that describe the attributes of that shape.  Known
   shapes are described below.   Note that colors should be entered as RGB for 
   vector graphics and a value for 
 
   SHAPE.shape = 'ellipse'
        .posxy = [x y]                   % center position
        .sizexy = [x y]                  % scale in x and y
        .linethickness = [x]             % thickness of outside line
        .linecolor = [r g b] or [n]      % line color, use empty if no line
        .fillcolor = [r g b] or [n]      % fill color, use empty [] if no fill
        .orientation = [theta];          % orientation in cartesian angles, degrees (0 is right)
 
   SHAPE.shape = 'rect'
        .posxy = [x y]                   % center position
        .sizexy = [x y]                  % scale in x and y
        .linethickness = [x]             % thickness of outside line
        .linecolor = [r g b] or [n]      % line color
        .fillcolor = [r g b] or [n]      % fill color, use empty ([]) if no fill
        .orientation = [theta]           % orientation in cartesian angles, degrees (0 is right)
 
   SHAPE.shape = 'arrow'
        .posxy = [x y]                   % center position
        .length= [x]                     % line length
        .linethickness = [x]             % thickness of line
        .linecolor = [r g b] or [n]      % line color
        .direction= [theta]              % direction in cartesian angles, degrees (0 is right)
        .headangle = [theta]             % angle of head sweep back (e.g., 30)
        .headlength = [x]                % head length (e.g., length/2)
