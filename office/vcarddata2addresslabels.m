function v = vcarddata2addresslabels(vcarddata, varargin)
% VCARD2LABELS - convert a VCARD file to a structure of label content
%
% V = VCARD2LABELS(VCARDDATA, ...)
%
% Identifies entries of the VCARDDATA (from VCARD2MAT) that have the
% field VFLAG. Then, an address is constructed and saved in the cell array
% of strings V. Each line of the address is a cell entry in the 2nd dimension
% of V (for example, V{i}{2} is the 2nd line of the ith address.
%
% This function also accepts name/value pairs that modify the default behavior:
% Parameter (Default)      | Description
% --------------------------------------------------------------------------
% VFLAG ('X-PHONETIC-ORG') | If this field is present, then the card should
%                          |    be included in addresses.
% ADDRESSTITLELINE         | The content of the first line of the address
%  ('X-PHONETIC-ORG')      |
% ADDRESS ('ADR')          | The field to use to grab the address. If this
%                          |    string ends the name of the field, it will be
%                          |    used.
% ADDRESS_TYPE ('HOME')    | The type of address to use
% 
%
% Example:
%    v = vcard2mat(fname);
%    vout = vcarddata2addresslabels(v);
%    addresslabels2pdf(vout)
%


VFLAG = 'X-PHONETIC-ORG';
ADDRESSTITLELINE = 'X-PHONETIC-ORG';
ADDRESS = 'ADR';
ADDRESS_TYPE = 'HOME';

v = {};

for i=1:numel(vcarddata),
	v_here = {};
	if isfield(vcarddata{i},matlab.lang.makeValidName(VFLAG)),
		% include it
		v_here{1} = getfield(vcarddata{i},matlab.lang.makeValidName(ADDRESSTITLELINE));
		foundaddress = 0;
		fn = fieldnames(vcarddata{i});
		for j=1:numel(fn),
			if endsWith(fn{j},ADDRESS),
				addrfield = getfield(vcarddata{i},fn{j});
				if iscell(addrfield) % also has to be a cell
					for k=1:numel(addrfield),
						if isfield(addrfield{k},'type'),
							if any(strcmp(ADDRESS_TYPE, addrfield{k}.type)),
								addlines = split(addrfield{k}.data,';');
								nonemptylines = [];
								for l=1:numel(addlines),
									if ~isempty(addlines{l}),
										nonemptylines(end+1)=l;
									end;
								end;
								addlines = addlines(nonemptylines);
								% combine lines 3-N-1
								addlines = {addlines{1}; char(join(addlines(2:end-1),' ')); addlines{end}};
								v_here = cat(1,v_here,addlines);
								foundaddress = 1;
								break;
							end
						end;
					end
				end
				if ~foundaddress,
				end
			end
		end
		if foundaddress,
			v{end+1} = v_here;
		else,
			warning(['Address error for following card:']);
			vcarddata{i},
		end;
	end
end
