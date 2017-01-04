function simple_batch(textfile)
% SIMPLE_BATCH - Run a simple batch
%
%   SIMPLE_BATCH(TEXTFILE)
%
%   Runs a simple batch script.
%
%   The TEXTFILE is assumed to be a tab-delimited text file with the first row
%   describing the fields (described here):
%   jobclaimfile -- the filename that will be created to "claim" the job for this Matlab
%   pathtorun -- the directory that will be changed to with the cd command
%   commandtorun -- the command that will be run
%   savefile -- the output will be saved to this file
%   errorsave -- if there is an error, the workspace will be saved to this file
%
%   

while 1,  % while we are not interrupted
	z = read_tab_delimited_file(textfile);

	for i=2:length(z),
		for j=1:5,
			z{i}{j} = strtrim(z{i}{j});
		end;
		disp('');
		disp('');
		disp(['---------------------------']);
		disp(['***Evaluating job ' z{i}{1} ' with save file ' z{i}{4} ' and error file ' z{i}{5} '.']);
		disp(['---------------------------']);
		% move to the appropriate directory
		try,
			cd(z{i}{2});
		catch,
			error(['Could not change to directory ' z{i}{2} '.']);
		end;
	
		% now try to grab the job
	
		if ~(exist(z{i}{1})==2),
			fid = fopen(z{i}{1},'wt');
			if fid>0,
				fprintf(fid,['Started ' datestr(now) '\n']);
				fclose(fid);

				disp(['***Starting job ' z{i}{1} ' with save file ' z{i}{4} ' and error file ' z{i}{5} ', ' datestr(now) '.']);

				try,
					evalin('base','clear; clear mex;');
					evalin('base',z{i}{3});
					evalin('base','current_time = now; current_date_string = datestr(now);');
					assignin('base','command_string',z{i}{3});
					evalin('base',['save ' z{i}{4} ';']);
				catch,
					disp('job failed');
					le = lasterror;
					disp(le.message);
					assignin('base','theerror',lasterror);
					evalin('base',['save ' z{i}{5} ';']);
				end;
			else,
				disp(['Job already taken.']);
				% couldn't get it, move on
			end;
		else,
				disp(['Job already taken.']);
				% couldn't get it, move on
		end;
	end;

	disp(['Pausing between 10 and 20 seconds']);
	dowait(10+fix(10*rand));
end;

