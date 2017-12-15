function spreadsheet_out = spreadsheet_filterbydate(spreadsheet_in, datelow, datehigh, varargin)
% SPREADSHEET - Filter a spreadsheet for fields defined by a Timestamp field
%  
%
% SPREADSHEET_OUT = SPREADSHEET_FILTERBYDATE(SPREADSHEET_IN, DATELOW, DATEHIGH, ...)
%
% Filters a spreadsheet (cell array) SPREADSHEET_IN to exclude rows that have a 'timestamp'
% field entry outside of the range DATELOW to DATEHIGH.
%
% DATELOW and DATEHIGH can be any date string that is recognized by the Matlab function
% DATENUM. (For example, 'YYYY-MM-DD' is acceptable and unambiguous.)
%
% This function can also take name/value pairs that modify its behavior.
% Parameter (default)      | Description
% -------------------------------------------------------------------------------
% FirstRowIsHeader (1)     | Is the first row a header?
% LeaveHeader (1)          | Leave the header in the filtered spreadsheet
% TimestampColumnLabel     | The label of the timestamp column
%   ('Timestamp')          |
% TimestampColumnNumber    | The column of the timestamp column. If empty, will be
%          ('')            |   searched for using TimestampColumnLabel.
%
% See also: DATENUM, NAMEVALUEPAIR 


FirstRowIsHeader = 1;
LeaveHeader = 1;
TimestampColumnLabel = 'Timestamp';
TimestampColumnNumber = [];

assign(varargin{:});

datenumlow = datenum(datelow);
datenumhigh = datenum(datehigh);

spreadsheet_rows_to_include = [];

if ~FirstRowIsHeader & isempty(TimestampColumnNumber),
	error(['No header indicated and no column number indicated; do not know how to find timestamp.']);
end;

if FirstRowIsHeader & isempty(TimestampColumnNumber),
	TimestampColumnNumber = find(strcmp(TimestampColumnLabel,spreadsheet_in(1,:)));

	if numel(TimestampColumnNumber)~=1,
		error(['Could not find a unique match for column with label ' TimestampColumnLabel '.']);
	end
end

if LeaveHeader,
	spreadsheet_rows_to_include = 1;
end;

for i=2:numel(spreadsheet_in(:,TimestampColumnNumber)),
	datestring = spreadsheet_in{i,TimestampColumnNumber};
	datehere = datenum(datestring);
	if datehere >= datenumlow & datehere <= datenumhigh,
		spreadsheet_rows_to_include(end+1) = i;
	end;
end

spreadsheet_out = spreadsheet_in(spreadsheet_rows_to_include,:);


