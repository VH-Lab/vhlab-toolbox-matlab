function matchaxes(axeslist, xmin, xmax, ymin, ymax)
% MATCHAXES - Set the axis limits on a set of axes to the same value
%
%  vlt.plot.matchaxes(AXESLIST, XMIN, XMAX, YMIN, YMAX)
%
%  For a list of axes handles AXESHANDLES, this function sets them all
%  to the same AXIS values.  If XMIN, XMAX, YMIN, YMAX are numerical values
%  then those values are used. A string can also be passed for XMIN, XMAX,
%  YMIN, or YMAX (or any combination). The string can be:
%  string:                       | Description 
%  ---------------------------------------------------------------------
%  'axis'                        | The function uses the minimum (for XMIN,
%                                | YMIN) or maximum (for XMAX, YMAX) of the
%                                | values currently on the axes.
%  'close'                       | The function uses the the min (or max) value
%                                | of the data plotted on the axes.
%
%  Note that this function doesn't install any code that will maintain
%  these axes relationships (if you change one axis, the others will not
%  automatically change). It simply sets the AXIS values at the time it is
%  called.
%
%  If XMIN==XMAX or YMIN==YMAX (for example, if the data points all have one value)
%  then vlt.plot.matchaxes subtracts 1 from the minimum and adds 1 to the maximum to avoid an 
%  error, and a warning is given.
%
%  Example: Rescale 2 axes so the Y axes are matched (from 0 to 1) and the X
%  axes are based on the maximum and minimum of the 2 axes specified.
%     % click in the first axes
%     myaxes1 = gca;
%     % click in the second axes
%     myaxes2 = gca;
%     vlt.plot.matchaxes([myaxes1 myaxes2],'axis','axis',0,1);
%
%  See also: AXES, AXIS

varnames = {'xmin','ymin','xmax','ymax'};
initial = [Inf Inf -Inf -Inf];
op = [0 0 1 1 ];
lim = {'xlim','ylim','xlim','ylim'};
data = {'xdata','ydata','xdata','ydata'};

for v=1:length(varnames),
	varval = eval(varnames{v});
	if ischar(varval),
		varval = initial(v);
		if strcmp(eval(varnames{v}), 'axis'),
			for i=1:length(axeslist),
				thelim = get(axeslist(i),lim{v});
				if ~op(v),
					varval = min(varval,thelim(1));
				else,
					varval = max(varval,thelim(2));
				end;
			end;
		elseif strcmp(eval(varnames{v}),'close'),
			for i=1:length(axeslist),
		 		ch = get(axeslist(i),'children');
				for j=1:length(ch),
					thedata = get(ch(j),data{v});
					if ~op(v),
						varval= min(varval,min(thedata(:)));
					else,
						varval= max(varval,max(thedata(:)));
					end;
				end;
			end;
		else,
			error(['Unknown string input ' varval '.']);
		end;
		vlt.data.assign(varnames{v},varval);
		if varval==initial(v),
			error(['Could not find data to constrain ' varnames{v} '.']);
		end;
	end;
end;

if xmin==xmax,
	warning(['XMIN==XMAX, leaving a gap of +/- 1']);
	xmin = xmin-1;
	xmax = xmax+1;
end;

if ymin==ymax,
	warning(['YMIN==YMAX, leaving a gap of +/- 1']);
	ymin=ymin-1;
	ymax=ymax+1;
end;

for i=1:length(axeslist),
	set(axeslist(i),'xlim',[xmin xmax],'ylim',[ymin ymax]);
end;
