function output = drawshape(shape, meshx, meshy)

% DRAWSHAPE -- Draw a simple shape in an image or as a vector plot
%
%
%  H = DRAWSHAPE(SHAPE)
%
%     Draws a shape using plots in current axes (vector mode).
%  H is a list of handles to the plots.
%
%  INDS = DRAWSHAPE(SHAPE, MESHX, MESHY)
%
%     Returns a set of indexes that will make SHAPE on a bitmap with
%  coordinate system MESHX x MESHY.  (See 'help mesh'.)
%
%    SHAPE should be a struct with fields that vary according to the shape
%  requested.  Each shape should have a field 'shape' that describes the shape,
%  and appropriate fields that describe the attributes of that shape.  Known
%  shapes are described below.   Note that colors should be entered as RGB for 
%  vector graphics and a value for 
%
%  SHAPE.shape = 'ellipse'
%       .posxy = [x y]                   % center position
%       .sizexy = [x y]                  % scale in x and y
%       .linethickness = [x]             % thickness of outside line
%       .linecolor = [r g b] or [n]      % line color, use empty if no line
%       .fillcolor = [r g b] or [n]      % fill color, use empty [] if no fill
%       .orientation = [theta];          % orientation in cartesian angles, degrees (0 is right)
%
%  SHAPE.shape = 'rect'
%       .posxy = [x y]                   % center position
%       .sizexy = [x y]                  % scale in x and y
%       .linethickness = [x]             % thickness of outside line
%       .linecolor = [r g b] or [n]      % line color
%       .fillcolor = [r g b] or [n]      % fill color, use empty ([]) if no fill
%       .orientation = [theta]           % orientation in cartesian angles, degrees (0 is right)
%
%  SHAPE.shape = 'arrow'
%       .posxy = [x y]                   % center position
%       .length= [x]                     % line length
%       .linethickness = [x]             % thickness of line
%       .linecolor = [r g b] or [n]      % line color
%       .direction= [theta]              % direction in cartesian angles, degrees (0 is right)
%       .headangle = [theta]             % angle of head sweep back (e.g., 30)
%       .headlength = [x]                % head length (e.g., length/2)
%
 
h = [];

if nargin>1,
	vectorgraphics = 0;
	bl = zeros(size(meshx));
else, vectorgraphics = 1;
end;

switch shape.shape,
case 'ellipse',
	xi_ = -shape.sizexy(1):(shape.sizexy(1)/50):shape.sizexy(1);
	yi_p= shape.sizexy(2)*sqrt(1-(xi_.^2)/(shape.sizexy(1).^2));
	yi_m= -shape.sizexy(2)*sqrt(1-(xi_.^2)/(shape.sizexy(1).^2));
	theta = -shape.orientation*pi/180;
	XIYI = ([ xi_ xi_(end:-1:1) ; yi_p yi_m(end:-1:1)]' * [cos(theta) -sin(theta); sin(theta) cos(theta)])';
	xi_ = XIYI(1,:); yi_ = XIYI(2,:);
	xi = xi_+shape.posxy(1); yi=yi_+shape.posxy(2);
	hold on;
	if vectorgraphics,
		if ~isempty(shape.fillcolor), h = [h patch(xi,yi,shape.fillcolor) ]; end;
		if ~isempty(shape.linecolor),
			h = [h plot(xi,yi,'color',shape.linecolor,'linewidth',shape.linethickness)];
		end;
	else,
		if ~isempty(shape.fillcolor),
			inds = find(inpolygon(meshx,meshy,xi,yi));
			bl(inds) = shape.fillcolor;
		end;
		if ~isempty(shape.linecolor),
			shape.sizexy = shape.sizexy + shape.linethickness,
			xi_ = -shape.sizexy(1):(shape.sizexy(1)/50):shape.sizexy(1);
			yi_pp= shape.sizexy(2)*sqrt(1-(xi_.^2)/(shape.sizexy(1).^2));
			yi_mm= -shape.sizexy(2)*sqrt(1-(xi_.^2)/(shape.sizexy(1).^2));

			XIYIo = ([ xi_ xi_(end:-1:1) ; yi_pp yi_mm(end:-1:1)]' * ...
					[cos(theta) -sin(theta); sin(theta) cos(theta)])';
			xi_ = XIYIo(1,:); yi_ = XIYIo(2,:);
			xi = xi_+shape.posxy(1); yi=yi_+shape.posxy(2);
			figure; plot(xi,yi,'g--'); hold on;

			shape.sizexy = shape.sizexy - 2 * shape.linethickness,
			xi_ = -shape.sizexy(1):(shape.sizexy(1)/50):shape.sizexy(1);
			yi_pm= shape.sizexy(2)*sqrt(1-(xi_.^2)/(shape.sizexy(1).^2));
			yi_mp= -shape.sizexy(2)*sqrt(1-(xi_.^2)/(shape.sizexy(1).^2));
			inds1a = find(inpolygon(meshx,meshy,xi,yi));
			xi_ = -shape.sizexy(1):(shape.sizexy(1)/50):shape.sizexy(1);
			XIYIi = ([ xi_ xi_(end:-1:1) ; yi_pm yi_mp(end:-1:1)]' * ...
					[cos(theta) -sin(theta); sin(theta) cos(theta)])';
			xi_ = XIYIi(1,:); yi_ = XIYIi(2,:);
			xi = xi_+shape.posxy(1); yi=yi_+shape.posxy(2);
			plot(xi,yi,'b--');
			inds1b = find(inpolygon(meshx,meshy,xi,yi));
			inds1 = setdiff(inds1a,inds1b);
			length(inds1),
			bl(inds1) = shape.linecolor;
		end;
	end;
case 'rect',
	xi_ = [ -shape.sizexy(1) -shape.sizexy(1) shape.sizexy(1) shape.sizexy(1) -shape.sizexy(1) ];
	yi_ = [ -shape.sizexy(2) shape.sizexy(2) shape.sizexy(2) -shape.sizexy(2) -shape.sizexy(2) ];
	theta = -shape.orientation*pi/180;
	XIYI = ([ xi_; yi_]' * [cos(theta) -sin(theta); sin(theta) cos(theta)])';
	xi_ = XIYI(1,:); yi_ = XIYI(2,:);
	xi = xi_+shape.posxy(1); yi=yi_+shape.posxy(2);
	
	if vectorgraphics,
		hold on;
		if ~isempty(shape.fillcolor),
	                h=[h patch(xi,yi,shape.fillcolor)];
		end;
		if ~isempty(shape.linecolor),
			h=[h plot(xi,yi,'linewidth',shape.linethickness,'color',shape.linecolor)];
		end;
	else,
		if ~isempty(shape.fillcolor),
			inds = inpolygon(meshx,meshy,xi,yi);
			bl(inds) = shape.fillcolor;
		end;
		if ~isempty(shape.linecolor),
			th = shape.linethickness;
			xi_p = [ -shape.sizexy(1)-th -shape.sizexy(1)-th shape.sizexy(1)+th shape.sizexy(1)+th -shape.sizexy(1)-th ];
			yi_m = [ -shape.sizexy(2)+th shape.sizexy(2)-th shape.sizexy(2)-th -shape.sizexy(2)+th -shape.sizexy(2)+th ];
			xi_m = [ -shape.sizexy(1)+th -shape.sizexy(1)+th shape.sizexy(1)-th shape.sizexy(1)-th -shape.sizexy(1)+th ];
			yi_p = [ -shape.sizexy(2)-th shape.sizexy(2)+th shape.sizexy(2)+th -shape.sizexy(2)-th -shape.sizexy(2)-th ];
			XIYIp = ([ xi_p ; yi_p]' * [cos(theta) -sin(theta); sin(theta) cos(theta)])';
			xi_ = XIYIp(1,:); yi_ = XIYIp(2,:);
			xi = xi_+shape.posxy(1); yi=yi_+shape.posxy(2);
			inds1a = find(inpolygon(meshx,meshy,xi,yi));
			XIYIm = ([ xi_m ; yi_m]' * [cos(theta) -sin(theta); sin(theta) cos(theta)])';
			xi_ = XIYIm(1,:); yi_ = XIYIm(2,:);
			xi = xi_+shape.posxy(1); yi=yi_+shape.posxy(2);
			if yi_p(1)>yi_m(1),
				inds1b = find(inpolygon(meshx,meshy,xi,yi));
				inds1 = setdiff(inds1a,inds1b);
			else,
				inds1 = inds1a;
			end;
			bl(inds1) = shape.linecolor;
		end;
	end;
case 'arrow',
	% assume the arrow is a set of lines
	if vectorgraphics,
		l1 = struct('shape','rect','posxy',shape.posxy,'sizexy',[shape.length 0],'linethickness',shape.linethickness,...
			'linecolor',shape.linecolor','fillcolor',[],'orientation',shape.direction);
		h = [h drawshape(l1)];
		theta = -shape.direction*pi/180;
		endpoint = ([shape.length; 0]' * [cos(theta) -sin(theta); sin(theta) cos(theta)])+shape.posxy;
		theta1 = (-theta+(shape.headangle)*pi/180);
		head1 = endpoint + [-1 1].*([shape.headlength; 0]' * [cos(theta1) -sin(theta1); sin(theta1) cos(theta1)]);
		l2 = struct('shape','rect','posxy',head1,'sizexy',[shape.headlength 0],'linethickness',shape.linethickness,...
			'linecolor',shape.linecolor','fillcolor',[],'orientation',theta1*180/pi);
		h = [h drawshape(l2)]; 
		theta2 = (-theta-(shape.headangle)*pi/180);
		head2 = endpoint + [-1 1].*([shape.headlength; 0]' * [cos(theta2) -sin(theta2); sin(theta2) cos(theta2)]);
		l3 = struct('shape','rect','posxy',head2,'sizexy',[shape.headlength 0],'linethickness',shape.linethickness,...
			'linecolor',shape.linecolor','fillcolor',[],'orientation',theta2*180/pi);
		h=[h drawshape(l3)];
	else,
		thetahead = shape.headangle*pi/180;
		th = shape.linethickness;
		xup = shape.length-(shape.headlength+th * cos(thetahead)); yup = (th+shape.headlength) * sin(thetahead);
		yup2 = yup - 2*th*sin(pi/2-thetahead); xup2 = xup - 2*th*cos(pi/2-thetahead); xdwn = xup2+(yup2-th)/tan(thetahead);
		xi_ = [-shape.length -shape.length xdwn xup2 xup shape.length xup xup2 xdwn -shape.length];
		yi_ = [-th           th            th              yup2 yup 0              -yup -yup2 -th             -th];
		theta = shape.direction*pi/180;
		XIYI = ([ xi_; yi_]' * [cos(theta) -sin(theta); sin(theta) cos(theta)])';
		xi_ = XIYI(1,:); yi_ = XIYI(2,:);
		xi = xi_+shape.posxy(1); yi=yi_+shape.posxy(2);
		inds = find(inpolygon(meshx,meshy,xi,yi));
		bl(inds) = shape.linecolor;
	end;
otherwise,
	warning(['unknown shape: ' shape.shape '.']);
end;

output = [];
if vectorgraphics,
	output = h;
else, output = bl;
end;
