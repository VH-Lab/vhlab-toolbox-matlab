function newds = update(ds)

% NEWDS = UPDATE(MYDIRSTRUCT)
%
%  Examines the path of the DIRSTRUCT and updates all of the structures.

if exist(ds.pathname)~=7, error(['''' pathname ''' does not exist.']); end;

dse = length(ds.dir_str);
nse = length(ds.nameref_str);
d = dir(ds.pathname);
[y,I]=sort({d.name});
d = d(I);
for i=1:length(d),
	if ~(strcmp(d(i).name,'.')|strcmp(d(i).name,'..')|d(i).name(1)=='.'), % ignore these
		fname = [ds.pathname fixpath(d(i).name) 'reference.txt'];
		if exist(fname)&(isempty(intersect(d(i).name,ds.dir_list))),
			% add directory to list, add namerefs to other list
			a= loadStructArray(fname);
			%disp(['Loaded ' d(i).name filesep 'acqParams_out']);
			n = { a(:).name }; r = { a(:).ref }; t = { a(:).type };
			if ~isempty(n),
				namerefs = cell2struct(cat(1,n,r,t)',{'name','ref','type'},2);
			else,
				namerefs = struct('name','','ref','','type',''); namerefs = namerefs([]);
			end;
			ds.dir_str(dse+1) = struct('dirname',d(i).name,'listofnamerefs',namerefs);
			ds.dir_list = cat(1,ds.dir_list,{d(i).name});
			ds.active_dir_list = cat(1,ds.dir_list,{d(i).name});
			dse = dse + 1;
			for j=1:length(namerefs),
				ind = namerefind(ds.nameref_str,namerefs(j).name,namerefs(j).ref);
				if ind>-1, % append to existing record
					ds.nameref_str(ind).listofdirs = cat(1,ds.nameref_str(ind).listofdirs, {d(i).name});
				else, % add new record
					tmpstr = struct('name',namerefs(j).name,'ref',namerefs(j).ref,'type',namerefs(j).type);
					tmpstr.listofdirs = {d(i).name};
					ds.nameref_str(nse+1) = tmpstr;
					ds.nameref_list(nse+1)  = struct('name',...
					namerefs(j).name,'ref',namerefs(j).ref,'type',namerefs(j).type);
					% also add new extractor record
					ind2=typefind(ds.autoextractor_list,t{j});
					if ind2>0,
						tmpstr.extractor1=ds.autoextractor_list(ind2).extractor1;
						tmpstr.extractor2=ds.autoextractor_list(ind2).extractor2;
					else,
						tmpstr.extractor1='';tmpstr.extractor2='';
					end;
					tmpstr = rmfield(tmpstr,'listofdirs');
					ds.extractor_list(end+1) = tmpstr;
					% inc counter
					nse = nse + 1;
				end;	
			end;
		end;
	end;
end;

newds = ds;
