function modelelstruct = modelel_convertfromc(desc_str)
% MODELEL_CONVERTFROMC - Convert the text string output of the executable file to a Matlab modelel
%
%   MODELELSTRUCT = vlt.neuro.models.modelel.modelelrun.modelel_convertfromc(DESC_STR)
%
%   Given a full, multi-line string, converts to Matlab structures.
%
%   Example input:
%   eol = sprintf('\n');                   % end of line character
%   desc_str = ['0:' eol ...               % first element
%          'type: spiketimelistel' eol ... % indicates type
%          'index: 1' eol ...              % the element number
%          'modelel: <' eol ...            % indicates that the variables associated with the modelel are coming next
%          'T: 0' eol ...                  % indicates that the variable 'T' has a value of 0
%          'dT: 0.0001' eol ...            % indicates that the variable dT has a value of 0.0001
%          'name: cell1' eol ...           % name is 'cell1'
%          '>' eol ...                     % end 'modelel'
%          'spiketimelistel: < ' eol ...   % variables specific to class spiketimelistel coming next
%          'spiketimelist: 0.0001' eol ... % list of spike times
%          '>' eol ...                     % indicate end of subobject
%          eol ...                         % blank line ends it
%          '1: ' eol ...
%          'Type: spiketimelistel' eol ... % indicates type
%          'index: 1' eol ...              % the element number
%          'modelel: <' eol ...            % indicates that the variables associated with the modelel are coming next
%          'T: 0' eol ...                  % indicates that the variable 'T' has a value of 0
%          'dT: 0.0001' eol ...            % indicates that the variable dT has a value of 0.0001
%          'name: cell1' eol ...           % name is 'cell1'
%          '>' eol ...                     % end 'modelel'
%          'spiketimelistel: < ' eol ...   % variables specific to class spiketimelistel coming next
%          'spiketimelist: 0.0002' eol ... % list of spike times
%          '>' eol ...                     % indicate end of subobject
%          eol ...                         % blank line ends it
%          ];
%
%

structinput = vlt.data.text2struct(desc_str),

if ~iscell(structinput), structinput = {structinput}; end; % make sure we have a list to process

 % eliminate any empty entries

goodinds = [];
for i=1:length(structinput),
        if length(fieldnames((structinput{i})))>0, goodinds(end+1) = i; end;
end;
structinput = structinput(goodinds);

modelelstruct = [];

for i=1:length(structinput),
	if exist([structinput{i}.type '_initc'])==2, % if we have a custom conversion function, call it
		newmodelel = eval([structinput{i}.type '_initc(structinput{i});']);
	else, % do the default thing
		fn = fieldnames(structinput{i});
		inputs = {};
		for j=1:length(fn),
			v = getfield(structinput{i},fn{j});
			if isstruct(v),
				fn1 = fieldnames(v);
				for k=1:length(fn1),
					inputs{end+1} = fn1{k};
					inputs{end+1} = getfield(v,fn1{k});
				end;
			end;
		end;
		newmodelel = eval([structinput{i}.type '_init(inputs{:});']);
	end;
	if ~isempty(modelelstruct),
		modelelstruct(end+1) = newmodelel;
	else,
		modelelstruct = newmodelel;
	end;
end;

  % need to convert variables

  % 1_T  -> search for whole structure for the T? Yes
  

