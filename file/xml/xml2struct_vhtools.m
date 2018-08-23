function stc = xml2struct(xmlstr, begT,begTI,begTIe,wholeT,wholeTI,wholeTIe,endT,endTI,endTIe)

%XML2STRUCT - An incomplete xml string to struct conversion program
%
%  STC = XML2STRUCT(XMLSTR)
%
%    Converst some XML strings into Matlab structures.
%
%     Accepts items in the format:
%
%         <word><CONTENTS</word>
%         or <word param1="value 1" param2="value 2" WS param3="value 3"/>
%         or <WS word WS param1="value1" WS param2="value2" WS param3="value3" WS></word>
%  
%  STC is a struct with entries corresponding to the headings and parameters/values in the XML string.
%
%
%  Note that this function will not process an arbitrary xml string but only files that use the three
%  conventions described above.

stc = struct([]);

 % get next piece
 %  can be <word>CONTENTS</word> or 
 %  '<WS word WS  param1="value1" WS param2="value2" WS param3="value3" WS/> or
 %  '<WS word WS param1="value1" WS param2="value2" WS param3="value3" WS></word>
 %  
 % where WS is optional whitespace

 % first pass through, get:
 %  <thing WHATEVER> (called begs), </thing> (called ends) and <thing WHATEVER/>(whole)

if nargin<2,

[begT,begTI,begTIe] = regexp(xmlstr,'\<(\s*)(\w+)([^>]*)>','tokens','start','end');
[wholeT,wholeTI,wholeTIe] = regexp(xmlstr,'\<(\s*)(\w+)([^>]*)/>','tokens','start','end');
[endT,endTI,endTIe] = regexp(xmlstr,'\<(\s*)/(\w+)(\s*)>','tokens','start','end');

 % begs will also include wholes and ends, so remove them

[dummy,inds] = setdiff(begTI-1,endTI); begT = begT(inds); begTI = begTI(inds); begTIe = begTIe(inds);
[dummy,inds] = setdiff(begTI,wholeTI); begT = begT(inds); begTI = begTI(inds); begTIe = begTIe(inds);

end;
 
 % find the first thing

ind1 = 1; ind2 = 1; ind3 = 1;

while (ind1<=length(begTI)|ind2<=length(endTI)|ind3<=length(wholeTI)),

if ind1<=length(begTI)&~isempty(begTI), m1 = begTI(ind1);     else, m1 = Inf; end;
if ind2<=length(endTI)&~isempty(endTI), m2 = endTI(ind2);     else, m2 = Inf; end;
if ind3<=length(wholeTI)&~isempty(wholeTI), m3 = wholeTI(ind3); else, m3 = Inf; end;

[m,i] = min([m1 m3 m2]);

switch i,
	case 1, % beginning, pinch off data and call recursively
		begInd = ind1;
		w = begT{ind1}{2};
		ind1 = ind1 + 1;
		depth=1;
		while depth>0&(ind1<=length(begTI)|ind2<=length(endTI)|ind3<=length(wholeTI)),
			if ind1<=length(begTI)&~isempty(begTI), m1 = begTI(ind1); else, m1 = Inf; end;
			if ind2<=length(endTI)&~isempty(endTI), m2 = endTI(ind2); else, m2 = Inf; end;
			if ind3<=length(wholeTI)&~isempty(wholeTI), m3 = wholeTI(ind3); else, m3 = Inf; end;
			[loc,i] = min([m1 m3 m2]);
			if i==1,
				if strcmp(w,begT{ind1}{2}), depth = depth + 1; end;
				ind1 = ind1 + 1;
			elseif i==3,
				if strcmp(w,endT{ind2}{2}), depth = depth - 1; end;
				ind2 = ind2 + 1;
			% if i==2, just skip it
			else,
				ind3 = ind3 + 1;
			end;
		end;
		if depth~=0, error(['Error processing field ' w ', character ' int2str(m) '.']); end; 
		low = begTIe(begInd)+1;  high = endTI(ind2-1)-2;
		IND1 = find(begTI>=low&begTI<=high);
		IND2 = find(endTI>=low&endTI<=high);
		IND3 = find(wholeTI>=low&wholeTI<=high);
		%if strcmp(w,'ImageDescription'),keyboard; end;
		%if strcmp(w,'Channels'), keyboard; end;
		data = xml2struct(xmlstr(low:high),begT(IND1),begTI(IND1)-low+1,begTIe(IND1)-low+1,...
			wholeT(IND3),wholeTI(IND3)-low+1,wholeTIe(IND3)-low+1,...
			endT(IND2),endTI(IND2)-low+1,endTIe(IND2)-low+1);
		if ~isempty(begT{begInd}{3}),
			data = addthexmlparameters(data,begT{begInd}{3});
		end;
		if ~isfield(stc,w),
			if isempty(stc),
				eval(['newstc.' w '={data};']);
				stc = newstc;
			else, stc = setfield(stc,w,{data});
			end;
		else,
			thecell = getfield(stc,w); thecell{end+1} = data;
			stc = setfield(stc,w,thecell);
		end;
	case 2, % whole, add it to the struct
		w = wholeT{ind3}{2};
		data = addthexmlparameters(struct([]),wholeT{ind3}{3});
		if ~isfield(stc,w),
			if isempty(stc),
				eval(['newstc.' w '={data};']);
				stc = newstc;
			else, stc = setfield(stc,w,{data});
			end;
		else,
			thecell = getfield(stc,w); thecell{end+1} = data;
			stc = setfield(stc,w,thecell);
		end;
		ind3 = ind3 + 1;
	case 3, % end, return the struct
		ind2 = ind2 + 1;
		warning(['got extra end ' w]);
end;

end;


function data = addthexmlparameters(stc,str)

toks = regexp(str,'(\w+)=\"([^"]*)"','tokens');
for i=1:length(toks),
	val = toks{i}{2};
	if isempty(setdiff(val,'01234567890.')), val = str2num(val); end;
	if isempty(stc),
		eval(['newstc.' toks{i}{1} '=val;']);
		stc = newstc;
	else, stc = setfield(stc,toks{i}{1},val);
	end;
end;

data = stc;

return;


