function saveexpvar(cksds, vrbl, name, pres)

%  SAVEEXPVAR (MYDIRSTRUCT, VARIABLE, NAME [, PRES])
%
%  Saves an experiment variable VARIABLE to DIRSTRUCT MYDIRSTRUCT with
%  the name NAME.  If PRES is 1, then if CELLVAR is of type MEASUREDDATA, then
%  any associates of MEASUREDDATA are preserved.
%
%  VARIABLE and NAME can also be cell lists of variables and variable names.

if nargin==4, preserved = pres; else, preserved = 0; end;

fn = getexperimentfile(cksds,1);
if exist(fn)==2,
	a = [];
	warnstate = warning('off');
	l_ = whos('-file',fn);
	if isempty(fieldnames(l_)), doappend = 0; else, doappend=1; end;
	warning(warnstate);
	if preserved,
		warnstate = warning('off');
		l=load(fn,name,'-mat');
		warning(warnstate);
		if strcmp(version,'5.2.1.1421'), % bug in Mac matlab passing empty structs
			if isempty(fieldnames(l)), isafield = 0;
			else, isafield = isfield(l,name); end;
		else, isafield = isfield(l,name);
		end;
		if isafield,
			gf = getfield(l,name);
			a=getassociate(gf,1:numassociates(gf));
			if isempty(a), a = []; end;
		end;
	end;
	if ~isempty(a),
		b = getassociate(vrbl,1:numassociates(vrbl));
		if isempty(b), b = []; end;
		a = [a b];
		if ~isempty(b),vrbl=disassociate(vrbl,1:numassociates(vrbl));end;
		for i=1:length(a), vrbl=associate(vrbl,a(i)); end;
	end;
	eval([name '=vrbl;']);
	fnlock = [fn '-lock']; % a cheesy semaphore implementation
	openedlock = 0;
	loops = 0;
	while (exist(fnlock,'file')==2)&loops<30,
		vlt.time.dowait(rand); loops = loops + 1;
	end;
	if loops==30, error(['Could not save ' name ' to file ' fn ': file is locked by the existence of experiment-lock file in analysis directory']); end;
   	fid0=fopen(fnlock,'w'); if fid0>0, openedlock = 1; end;
	try, if doappend, save(fn,name,'-append','-mat'); else, save(fn,name,'-mat'); end;
	catch,
		if openedlock, delete(fnlock); end;
		error(['Could not save ' name ' to file ' fn '.']);
	end;
	if openedlock, fclose(fid0); delete(vlt.file.fixtilde(fnlock)); end;
end;
