function answers = spreadsheet_multiplechoice(spreadsheet, question, varargin)
% SPREADSHEET_MULTIPLECHOICE - Return answers to a multiple choice spreadsheet question
%
% ANSWERS = SPREADSHEET_MULTIPLECHOICE(SPREADSHEET, QUESTION, ...)
%
% Returns a structure with responses to a multiple choice "question"
% in the header row of a spreadsheet. The header row is assumed to be the first
% row.
%
% The structure ANSWERS has 3 fields: question (the question asked), choices
% (a cell array of strings of the choices), and results (a vector of how many choices
% of each type were made).
%
% This function can also take name/value pairs that modify its behavior:
% Parameter (default)    | Description
% --------------------------------------------------------------------
% choices ([])           | If the user wishes to provide the choices, one
%                        |   can. This is useful for prescribing the order
%                        |   of the choices, or for indicating the possibility of
%                        |   choices that are not represented in the data. If empty,
%                        |   then choices will be determined empircally by the entries
%                        |   in the spreadsheet.
%
% See also: NAMEVALUEPAIRS

choices = [];

assign(varargin{:});

question_column = find(strcmpi(question, spreadsheet(1,:)));

if numel(question_column)~=1,
	error([question ' does not uniquely specify a single column.']);
end;

thequestion = spreadsheet{1,question_column};

A = spreadsheet(:,question_column)

if isempty(choices),
	choices = unique(spreadsheet(2:end,question_column)); 
end;

results = [];

for i=1:numel(choices),
	tf = strcmpi(allanswers{i},spreadsheet(2:end,question_column));
	results(i) = sum(tf);
end;
	
answers = struct('question',question,'choices',choices,'results',results);
