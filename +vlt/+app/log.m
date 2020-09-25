classdef log < handle
	% vlt.app.log: A logger for system and/or error messages by a Matlab application or package
	%
	% vlt.app.log is an API and implementation for writing messages to a log file. 
	% This is useful for monitoring program operation, debugging, and helping end-users diagonose
	% problems. It also allows the program not to write all messages to the command line, which can
	% be confusing for end-users (or even developers).
	%
	% vlt.app.log Properties:
	%   system_logfile - A character string with the full path to the system log file
	%   error_logfile - A character string with the full path to the error log file
	%   debug_logfile - A character string with the full path to the debug log file
	%   system_verbosity - A double number that indicates whether or not a system message should be written.
	%                    If a message priority exceeds verbosity, it will be written to the log
	%   error_verbosity - A double number that indicates whether or not an error message should be written.
	%                    If a message priority exceeds verbosity, it will be written to the log
	%   debug_verbosity - A double number that indicates whether or not a debugging message should be written.
	%                    If a message priority exceeds verbosity, it will be written to the log
	%   log_name - The name to preprend to each log message as '[log_name] '.
	%   log_error_behavior - A string that indicates what the log should do if it cannot write a message to the 
	%                        log file. Valid values are 'Error', 'Warning', 'WriteToStdOut', 'WriteToStdErr', 'Nothing'
	%

	properties
		system_logfile % A character string with the full path to the system log file
		error_logfile % A character string with the full path to the error log file
		debug_logfile % A character string with the full path to the debug log file
		system_verbosity % A double number that indicates whether or not a system message should be written.
		error_verbosity % A double number that indicates whether or not an error message should be written.
		debug_verbosity % A double number that indicates whether or not a debugging message should be written.
		log_name % The name to preprend to each log message as '[log_name] '.
		log_error_behavior % A string that indicates what the object should do if it cannot write a message to the file

	end; % properties

	methods
		
		function log_obj = log(varargin)
			% LOG - create a vlt.app.log for writing system, debugging, error information to log files
			%
			% LOG_OBJ = LOG(PROPERTY1, VALUE1, ... )
			%
			% Creates a new MATAPPTOOLS.LOG object with the properties initiallized with name/value pair
			% arguments. If not specified, the default values of the parameters are the following:
			%
			% Property                  | Default_value
			% ---------------------------------------------------------
			% system_logfile            | [userpath filesep 'system.log']
			% error_logfile             | [userpath filesep 'error.log']
			% debug_logfile             | [userpath filesep 'debug.log']
			% system_verbosity          | 1.0
			% error_verbosity           | 1.0
			% debug_verbosity           | 1.0
			% log_name                  | ''
			% log_error_behavior        | 'Nothing'
			%
				system_logfile = [userpath filesep 'system.log'];
				error_logfile = [userpath filesep 'error.log'];
				debug_logfile = [userpath filesep 'debug.log'];

				system_verbosity = 1.0;
				error_verbosity = 1.0;
				debug_verbosity = 1.0;

				log_error_behavior = 'Nothing';

				vlt.data.assign(varargin{:});

				fn = fieldnames(log_obj);
				for i=1:numel(fn),
					log_obj = setfield(log_obj,fn{i},eval(fn{i}));
				end;

		end; % log(), constructor

		function b = msg(log_obj, type,priority,message)
			% MSG - write a log message to the log
			%
			% B = MSG(LOG_OBJ, TYPE, PRIORITY, MESSAGE)
			%
			% Appends the character string MESSAGE to the appropriate log file for the matapptools.log object
			% LOG_OBJ. If the message exceeds the verbosity PRIORITY  for that message type, then the message is
			% written. Possible values for type are 'SYSTEM', 'ERROR', and 'DEBUG' (not case sensitive). 
			% The word SYSTEM, ERROR, or DEBUG is pre-pended to the message.
			%
			% It is good form for MESSAGE to end with a period. A newline is added after MESSAGE.
			%
			% A time stamp is added to the beginning of the log message, in UTC leap seconds.
			%
			% B is 1 if the operation is successful, and 0 otherwise. The error behavior is determined
			% by LOG_OBJ.LOG_ERROR_BEHAVIOR.
			%
			% Example: 
			%   log_obj.msg('system',1,'starting my program');
			%   log_obj.msg('error',1,'Could not find file C:\mydir\abc.txt.');
			%   log_obj.msg('debug',1,'a=5 here.');
			%
				timestamp = [char(datetime('now','TimeZone','UTCLeapSeconds'))];
				themsg = [timestamp ' [' log_obj.logname '] ' upper(type) ' ' message '].
				
				switch upper(type),
					case 'SYSTEM',
						[b,errormsg]=vlt.file.addline(log_obj.system_logfile, themsg);
					case 'ERROR',
						[b,errormsg]=vlt.file.addline(log_obj.error_logfile, themsg);
					case 'DEBUG',
						[b,errormsg]=vlt.file.addline(log_obj.debug_logfile, themsg);
					otherwise,
						error(['Invalid log type: ' type '; expected SYSTEM, ERROR, or DEBUG']);
				end;
		end; 

	end; % methods

end % class (log)
