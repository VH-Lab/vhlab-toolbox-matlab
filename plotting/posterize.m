function posterize(fignum, varargin)

% POSTERIZE - Change plot characteristics appropriate for posters
%
%  POSTERIZE(FIGNUM, ...)
%
%  Changes plot characteristics appropriate for a poster.  By default:
%  '_axes_fontsize' is set to 10
%  '_axes_xlabel_fontsize' is set to 13
%  '_axes_ylabel_fontsize' is set to 13
%  '_axes_title_fontsize' is set to 13
%  'fontname' is set to arial
%  '_axes_box' is set to 'off'
%
%  If additional arguments are provided in name/value pairs, then
%  the function will attempt to set fields with each name to the
%  value specified.  If the variable name has the form '_TYPE_FIELDNAME',
%  then only fields of handles of type TYPE will be changed.  This can be
%  extended to '_TYPE_HANDLENAME_FIELDNAME' and
%  '_TYPE_HANDLENAME_..._HANDLE_NAME_FIELDNAME'
%
%  Examples:
%
%  POSTERIZE(FIGNUM,'linewidth',2) will set the value of
%    the field 'linewidth' to 2 in all handles that possess it.
%  POSTERIZE(FIGNUM,'_axes_fontsize',20) sets the value of the field
%    'fontsize' in all handles of type 'axes'.
%  POSTERIZE(FIGNUM,'_axes_xlabel_fontsize',13) sets the value of the field
%    'fontsize' in all handles called 'xlabel' in objects of type 'axes'


myvarargin = {'_axes_fontsize',10, '_axes_xlabel_fontsize', 13, '_axes_ylabel_fontsize', 13, ...
	'_axes_title_fontsize' , 13, 'fontname', 'Arial', '_axes_box','off'};

myvarargin = cat(2,myvarargin,varargin);

if mod(length(varargin),2)~=0,
	error(['Extra arguments to POSTERIZE must be in pairs.']);
end;

for i=1:2:length(myvarargin),
	underscores = find(myvarargin{i}=='_');
	if strcmp(myvarargin{i}(1),'_')&length(underscores)>=2,
		type = myvarargin{i}(underscores(1)+1:underscores(2)-1),
		h = findobj(fignum,'type',type);
		hi = h;
		iter = 2;
		while length(hi)>0 & iter<length(underscores),
			hn = [];
			nextfield = myvarargin{i}(underscores(iter)+1:underscores(iter+1)-1),
			for j=1:length(hi),
				try,
					h_ = get(hi(j),nextfield);
					hn = cat(2,hn,h_);
				end;
			end;
			hi = hn,
			iter = iter+1;
		end;
		for j=1:length(hi), try, set(hi(j),myvarargin{i}(underscores(iter)+1:end),myvarargin{i+1}); end; end;
	else,
		h=findobj(fignum,'-depth',Inf,'-property',myvarargin{i});
		if ~isempty(h), try, set(h,myvarargin{i},myvarargin{i+1}); end; end;
	end;
end;