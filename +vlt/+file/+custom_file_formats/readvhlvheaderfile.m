function mystruct = readvhlvheaderfile(myfilename)
% READVHLVHEADERFILE - Read VHLV header file format
%
%  HEADERSTRUCT = READVHLVHEADERFILE(MYFILENAME)
%
%   Reads the header file format for the VHLAB LabView
%   multichannel acquisition system.
%
%   It expects MYFILENAME to be the name of a text file, where each line
%   begins with a field name followed by a colon ':' and then a tab, followed
%   by the value. The expected fields are 'ChannelString', which indicates the
%   channel names that were acquired in the LabView system, 'NumChans', the number
%   of channels that were acquired, 'SamplingRate', the sampling rate of each
%   channel in Hz, and 'SamplesPerChunk', which indicates how many samples were
%   written to disk in each burst of recording.  'Multiplexed' indicates
%   whether adjacent samples are from different channels (1) or if 
%   the channel data is loaded in groups of SamplesPerChunk (0).
%
%   The channel numbers correspond to the inputs described in 'ChannelString'.
%   For example, if ChannelString is '/dev/ai0', then there is just 1 channel
%   and it corresponds to analog input 0 on the acquisition device.
%
%   Use READVHLVDATAFILE to read the data.
%
%   Example:
%     headerstruct = readvhlvheaderfile('vhlvanaloginput.vlh')
%
%     headerstruct = 
%         ChannelString: [1x26 char]
%              NumChans: 17
%          SamplingRate: 25000
%       SamplesPerChunk: 25000
%           Multiplexed: 0
%
%
%  See also STRUCT, READVHLVDATAFILE
%

 % step 1) create an empty field
mystruct.emptyfield = 0; % make a new struct
mystruct = rmfield(mystruct,'emptyfield'); % make it have no fields

 % step 2) read in the text from the header file
 %         we have no expectation that this will be large, so
 %         let's read the whole business at once

[wholepath,myfilenameactual,myext] = fileparts(myfilename);
if strcmp(upper(myext),upper('.vld')), 
	error(['It appears you are trying to open a data file ' myfilename ' with the code that reads the header.']);
end;

fid = fopen(myfilename,'rt');

if fid<0, error(['Could not open file ' myfilename '.']); end; % handle any errors nicely

textfromfile = fread(fid,Inf,'char');
fclose(fid);  % close the file

 % step 3) parse the text; 

text = [sprintf('\n') ; textfromfile(:) ]'; % add line feeds to beginning of the file

if text(end)~=sprintf('\n'),  % make sure the last line ends in a line feed
	text(end+1) = sprintf('\n');
end;

  % remove any carriage returns, which are redundent with line feeds
inds = find(text~=sprintf('\r'));  
text = text(inds);

  % now loop through, looking for the existence of a colon followed by a tab
  % the presence of a colon/tab indicates that everything to the left of the colon/tab on that
  % line is the header.  The contents will be everything to the right of the tab
  % until the next line that has a tab.  

separators = strfind(text,sprintf(':\t'));
linefeeds = find(text==sprintf('\n'));

for i=2:length(linefeeds),  % parse each line, starting from 2nd
	z = find(separators>linefeeds(i-1) & separators<linefeeds(i)); % does this line have a colon plus tab in it?
	if ~isempty(z),
		% the field name is the text between the beginning of the line and the colon
		field_name = text(linefeeds(i-1)+1:separators(z)-1);
		field_value_start = separators(z)+2; % there are 2 characters in the separator

		% now we have to find where the end is
		% let's find the next colon plus tab, if it exists
		z2 = find(separators>separators(z),1); % find at most 1 of these
		if ~isempty(z2), 
			next_linefeed = find(linefeeds<separators(z2),1,'last'); % find the last linefeed before the colon tab
			field_value_end = linefeeds(next_linefeed)-1;
		else, % read from here until the end of the document
			field_value_end = linefeeds(end)-1;
		end;
		field_value_string = text(field_value_start:field_value_end);

		% now try to add the field.  First, we'll try to add it as a number; if it fails, we'll add as a string

		try,
			mystruct = eval(['setfield(mystruct,field_name,' field_value_string ');']);
		catch,
			mystruct = setfield(mystruct,field_name,field_value_string);
		end;
	end;
end;


return

 % the old version

        mynextline = 0;
        while mynextline~=-1, % this will be -1 if fgetl can't read anything else
            mynextline = fgetl(fid);
            myseparator = strfind(mynextline, sprintf(':\t') ); % prints the string ':' followed by the tab character
            if ~isempty(myseparator),  % if we find an instance of the separator on this line, it is valid
                try      %first, try to evaluate the expression so if it is numerical, it will become a number
                    mystruct = eval(['setfield(mystruct,mynextline(1:myseparator(1)-1),' mynextline(myseparator(1)+2:end) ');']);
                catch, % but if this fails, set it to the string contents
                    mystruct = setfield(mystruct,mynextline(1:myseparator(1)-1),mynextline(myseparator(1)+2:end));
                end;
            end;
        end
    fclose(fid); % close our file
