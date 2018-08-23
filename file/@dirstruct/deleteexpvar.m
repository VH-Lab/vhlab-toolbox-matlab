function deleteexpvar(ds,variablenametobedeleted, additionalvariables, additionalvariablenames, preserveassociates)

% DELETEEXPVAR - Delete a variable from the experiment.mat file in a DIRSTRUCT 
%
%    DELETEEXPVAR(MYDIRSTRUCT,NAMETOBEDELETED)
%
%    Deletes an experiment variable from the DIRSTRUCT given.
%
%    NAMETOBEDELETED can be a single string or should be a cell list of strings of variable names.
%
%    Note that there must be enough memory to read in the entire 
%    set of saved variables for the DIRSTRUCT.
%
%    If one also wants to save some new data to the DIRSTRUCT, one can pass additional
%    arguments:
%
%    DELETEEXPVAR(MYDIRSTRUCT, NAMETOBEDELETED, ADDITIONALVARS, ADDITIONALVARNAMES, PRESERVE_ASSOCIATES)
%
%    This will delete the variables titled NAMETOBEDELETED, and add variables with names
%    ADDITIONALVARNAMES with data ADDITIONALVARS. ADDITIONALVARNAMES and ADDITIONALVARS
%    should be cell lists, so that ADDITIONALVARNAMES{i} is the name of the variable whose
%    data is ADDITIONALVARS{i}. If PRESERVE_ASSOCIATES is 1, then any associates of MEASUREDDATA objects
%    are preserved.  This form is functional equivalent to:
%            DELETEEXPVAR(MYDIRSTRUCT,NAMETOBEDELETED);
%            SAVEEXPVAR(MYDIRSTRUCT,ADDITIONALVARS,ADDITIONALVARNAMES,PRESERVE_ASSOCIATES);
%    but doing this in one step requires much less disk access and is faster.
%
%    See also: DIRSTRUCT, SAVEEXPVAR, GETEXPERIMENTFILE
%

if isempty(variablenametobedeleted)&nargin<3, return; end; % user asked for nothing, do nothing

if ischar(variablenametobedeleted), variablenametobedeleted = {variablenametobedeleted}; end;

fn_sev = getexperimentfile(ds);

if exist(fn_sev)==2,
	% step 1: see if we can lock the experiment.mat file so we will be guarenteed to be the only program changing it at 1 time

	fnlock_sev = [ fn_sev '-lock']; % semaphore
	loops_sev = 0;
	while (exist(fnlock_sev,'file')==2)&loops_sev<30,
		dowait(rand);
		loops_sev = loops_sev + 1;
	end;
	if loops_sev==30,
		error(['Could not control file ' fn_sev ': file is locked by the existence ' ...
			'of the experiment-lock file in the analysis directory.\n' ...
			'This could mean a program crashed (and you need to delete the ' ...
			'experiment-lock file in order to continue using it) or that another ' ...
			'Matlab process is currently writing to the experiment.mat file (and ' ...
			'you need to wait for it to finish).']);
	end;

	fid0_sev = fopen(fnlock_sev,'w');
	if fid0_sev>0,
		fclose(fid0_sev);
	else,
		error(['Could not open lock file at location ' fnlock_sev '.  Check that you have permission to write to that directory.']);
	end;

	% step 2: load variables; this might fail because of memory, so we will use 'try' to make sure we don't hog the lock file if we error

	try,
		data = load(fn_sev,'-mat');  % cant believe we cant use WHOS, but WHOS seems to need a file with an actual .mat extension
	catch,
		delete(fixtilde(fnlock_sev));
		error(['Could not read in variables from experiment.mat file ' fn_sev ', error is ' lasterr '.']);
	end;

	% step 3: delete variables from data in memory, add any requested variables

	variables_to_be_deleted = intersect(variablenametobedeleted,fieldnames(data)); % make sure the variable names are actually present in the file

	if ~isempty(variables_to_be_deleted),
		data = rmfield(data,variables_to_be_deleted);
	end;

	if isempty(variables_to_be_deleted)&nargin<3,
		% nothing to do, we are done
		delete(fixtilde(fnlock_sev));
		return; 
	end;

	if nargin>2,
		for i=1:length(additionalvariablenames),
			if preserveassociates&isfield(data,additionalvariablenames{i}),
				myvar = getfield(data,additionalvariablenames{i});
				if isa(myvar,'measureddata') && isa(additionalvariables{i},'measureddata'),
					myassoc = findassociate(myvar,'','','');
					for j=1:length(myassoc),
						[dummy,assoc_indexes] = findassociate(additionalvariables{i},myassoc(j).type,'','');
						additionvariables{i} = disassociate(additionalvariables{i},assoc_indexes);
						additionalvariables{i} = associate(additionalvariables{i},myassoc(j));
					end;
				end;
			end;
			data = setfield(data,additionalvariablenames{i},additionalvariables{i});
		end;
	end;

	% step 4: save data in memory back to disk

	if length(fieldnames(data)),
		save(fn_sev,'-struct','data','-mat');
	else,  % if there are no records then we need to delete the file
		delete(fn_sev); % delete the file
	end;
	
	% step 5: let go of the lock file so others can modify the experiment.mat file in the future

	fnlock_sev = [ fn_sev '-lock']; 
	delete(fixtilde(fnlock_sev));
else, % there is no experiment.mat file, just proceed as a normal save
    %warning('No experiment.mat file, creating it.'); % no need to warn
    if nargin>2,
        if ~isempty(additionalvariables),
            saveexpvar(ds,additionalvariables,additionalvariablenames,preserveassociates);
        end;
    end;
end;
