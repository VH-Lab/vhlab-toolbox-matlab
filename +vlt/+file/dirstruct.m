classdef dirstruct
    % vlt.file.dirstruct - Manage experimental data organized in directories
    %
    % This class is intended to manage experimental data. The data are organized
    % into separate test directories, with each directory containing one epoch
    % of recording. Each such directory has a file called 'reference.txt' that
    % contains information about the signals that were acquired during that epoch.
    %
    % properties:
    %   pathname - The path to the directory being managed
    %   nameref_str - Struct array of name/ref pairs
    %   dir_str - Struct array of directories
    %   nameref_list - Struct array of name/ref pairs (simplified)
    %   dir_list - Cell array of directory names
    %   extractor_list - Struct array of extractors
    %   autoextractor_list - Struct array of auto-extractors
    %   active_dir_list - Cell array of active directories
    %
    % methods:
    %   dirstruct - Constructor
    %   update - Update the structure by scanning the directory
    %   getactive - Get active directories
    %   getallnamerefs - Get all name/ref pairs
    %   getalltests - Get all test directories
    %   getcells - Get cells from the experiment
    %   getexperimentfile - Get the experiment file path
    %   getextractors - Get extractors
    %   getnamerefs - Get name/refs for a specific test directory
    %   getpathname - Get the pathname
    %   getscratchdirectory - Get the scratch directory
    %   getstimscript - Get the stimscript
    %   getstimscripttimestruct - Get the stimscript time struct
    %   gettag - Get a tag
    %   gettagvalue - Get a tag value
    %   gettests - Get test directories for a name/ref pair
    %   hastag - Check if a tag exists
    %   isactive - Check if a directory is active
    %   neuter - Disable a directory
    %   newtestdir - Get a suitable new test directory name
    %   addtag - Add a tag
    %   removetag - Remove a tag
    %   saveexpvar - Save an experiment variable
    %   deleteexpvar - Delete an experiment variable
    %   setactive - Set active directories

    properties
        pathname
        nameref_str
        dir_str
        nameref_list
        dir_list
        extractor_list
        autoextractor_list
        active_dir_list
    end

    methods
        function obj = dirstruct(pathname)
            % DIRSTRUCT - Constructor for vlt.file.dirstruct
            %
            % OBJ = vlt.file.dirstruct(PATHNAME)
            %
            % Returns a DIRSTRUCT object.

            arguments
                pathname (1,:) char = ''
            end

            if isempty(pathname)
                obj.pathname = '';
            else
                obj.pathname = vlt.file.fixpath(pathname);
                if exist(obj.pathname, 'dir') ~= 7
                     error(['''' pathname ''' does not exist.']);
                end
            end

            % Initialize empty structs
            obj.nameref_str = struct('name','','ref',0,'type','','listofdirs',{});
            obj.dir_str = struct('dirname','','listofnamerefs',{});
            obj.dir_list = {};
            obj.nameref_list = struct('name',{},'ref',{},'type','');
            obj.extractor_list = struct('name',{},'ref',{},'type','','extractor1','','extractor2','');
            obj.autoextractor_list = struct('type',{},'extractor1',{},'extractor2',{});
            obj.active_dir_list = {};

            if ~isempty(obj.pathname)
                obj = obj.update();
            end
        end

        function obj = update(obj)
            % UPDATE - Examines the path and updates all structures
            %
            % OBJ = UPDATE(OBJ)

            if exist(obj.pathname, 'dir') ~= 7
                error(['''' obj.pathname ''' does not exist.']);
            end

            dse = length(obj.dir_str);
            nse = length(obj.nameref_str);
            d = dir(obj.pathname);
            [~,I] = sort({d.name});
            d = d(I);

            for i = 1:length(d)
                if ~(strcmp(d(i).name,'.') || strcmp(d(i).name,'..') || d(i).name(1)=='.')
                    fname = [obj.pathname vlt.file.fixpath(d(i).name) 'reference.txt'];
                    if exist(fname, 'file') && isempty(intersect(d(i).name, obj.dir_list))
                        % add directory to list, add namerefs to other list
                        try
                            a = vlt.file.loadStructArray(fname);
                        catch
                            warning(['Could not load ' fname]);
                            a = [];
                        end

                        if ~isempty(a)
                            n = {a(:).name};
                            r = {a(:).ref};
                            t = {a(:).type};
                        else
                             n = {}; r = {}; t = {};
                        end

                        if ~isempty(n)
                            namerefs = cell2struct(cat(1,n,r,t)',{'name','ref','type'},2);
                        else
                            namerefs = struct('name','','ref','','type','');
                            namerefs = namerefs([]);
                        end

                        obj.dir_str(dse+1) = struct('dirname',d(i).name,'listofnamerefs',namerefs);
                        obj.dir_list = cat(1, obj.dir_list, {d(i).name});
                        obj.active_dir_list = cat(1, obj.active_dir_list, {d(i).name});
                        dse = dse + 1;

                        for j = 1:length(namerefs)
                            ind = obj.namerefind(obj.nameref_str, namerefs(j).name, namerefs(j).ref);
                            if ind > -1 % append to existing record
                                obj.nameref_str(ind).listofdirs = cat(1, obj.nameref_str(ind).listofdirs, {d(i).name});
                            else % add new record
                                tmpstr = struct('name',namerefs(j).name,'ref',namerefs(j).ref,'type',namerefs(j).type);
                                tmpstr.listofdirs = {d(i).name};
                                obj.nameref_str(nse+1) = tmpstr;
                                obj.nameref_list(nse+1) = struct('name',...
                                    namerefs(j).name,'ref',namerefs(j).ref,'type',namerefs(j).type);

                                % also add new extractor record
                                ind2 = obj.typefind(obj.autoextractor_list, t{j});
                                if ind2 > 0
                                    tmpstr.extractor1 = obj.autoextractor_list(ind2).extractor1;
                                    tmpstr.extractor2 = obj.autoextractor_list(ind2).extractor2;
                                else
                                    tmpstr.extractor1 = '';
                                    tmpstr.extractor2 = '';
                                end
                                tmpstr = rmfield(tmpstr, 'listofdirs');
                                obj.extractor_list(end+1) = tmpstr;
                                % inc counter
                                nse = nse + 1;
                            end
                        end
                    end
                end
            end
        end

        function dirlist = getactive(obj)
            % GETACTIVE - Returns a cell list of the active directories
            dirlist = obj.active_dir_list;
        end

        function NR = getallnamerefs(obj)
            % GETALLNAMEREFS - Returns a structure with all name/ref pairs
            NR = obj.nameref_list;
        end

        function t = getalltests(obj)
            % GETALLTESTS - Returns a list of all test directories
            t = obj.dir_list;
        end

        function C = getcells(obj, nameref, inds)
            % GETCELLS - Returns cells from the experiment
            C = {};
            e = obj.getexperimentfile();

            try
                if nargin == 1
                    g = load(e, 'cell*', '-mat');
                else
                    g = load(e, ['cell_' nameref.name '_' sprintf('%.4d',nameref.ref) '*'], '-mat');
                end

                if nargin < 3
                    C = fieldnames(g);
                else
                    f = fieldnames(g);
                    l = length(['cell_' nameref.name '_' sprintf('%.4d',nameref.ref) '_']);
                    for i = 1:length(f)
                        for j = 1:length(inds)
                            if strcmp(f{i}(l+1:l+3), sprintf('%.3d',inds(j)))
                                C = cat(2, C, f(i));
                                break;
                            end
                        end
                    end
                end
            catch
                % ignore errors
            end
        end

        function [p, expf] = getexperimentfile(obj, createit)
            % GETEXPERIMENTFILE - Returns the experiment data filename
            arguments
                obj
                createit (1,1) logical = false
            end

            expf = '';

            if exist(obj.pathname, 'dir') ~= 7
                p = [];
            else
                f = find(obj.pathname == filesep);
                if length(f) == 1
                    expf = obj.pathname([1:f-1 f+1:length(obj.pathname)]);
                else
                    expf = obj.pathname((f(end-1)+1):(f(end)-1));
                end
                str = vlt.file.fixpath([obj.pathname 'analysis']);
                p = [str 'experiment'];
                if createit
                    if exist(p, 'file') ~= 2
                        if exist(str, 'dir') ~= 7
                            mkdir(obj.pathname, 'analysis');
                        end
                        name = expf; %#ok<NASGU>
                        save(p, 'name', '-mat');
                    end
                end
            end
        end

        function [extractor1, extractor2] = getextractors(obj, name, ref)
            % GETEXTRACTORS - Get extractor info
            ind = obj.namerefind(obj.extractor_list, name, ref);
            if ind > 0
                extractor1 = obj.extractor_list(ind).extractor1;
                extractor2 = obj.extractor_list(ind).extractor2;
            else
                error('Could not find name/ref');
            end
        end

        function refs = getnamerefs(obj, testdir)
            % GETNAMEREFS - Return namerefs from a given test directory
            [~, loc, ~] = intersect(obj.dir_list, testdir);
            if ~isempty(loc)
                refs = obj.dir_str(loc).listofnamerefs;
            else
                refs = struct('name','tmp','ref',1,'type','');
                refs = refs([]); % make an empty one
            end
        end

        function p = getpathname(obj)
            % GETPATHNAME - Returns the pathname
            p = vlt.file.fixpath(vlt.file.fixtilde(obj.pathname));
        end

        function p = getscratchdirectory(obj, createit)
            % GETSCRATCHDIRECTORY - Returns the scratch directory path
            arguments
                obj
                createit (1,1) logical = false
            end

            if exist(obj.pathname, 'dir') ~= 7
                p = [];
            else
                str = [obj.pathname 'analysis' filesep];
                p = [str 'scratch' filesep];
                if createit
                    if exist(p, 'dir') ~= 7
                        if exist(str, 'dir') ~= 7
                            mkdir(obj.pathname, 'analysis');
                        end
                        mkdir(str, 'scratch');
                    end
                end
            end
        end

        function [saveScript, MTI] = getstimscript(obj, thedir)
            % GETSTIMSCRIPT - Gets the stimscript and MTI
            saveScript = [];
            MTI = [];

            p = obj.getpathname();

            if ~exist([p thedir], 'dir')
                error(['Directory ' p thedir ' does not exist.']);
            elseif ~exist([p vlt.file.fixpath(thedir) 'stims.mat'], 'file')
                error(['No stims in directory ' p thedir '.']);
            else
                g = load([p vlt.file.fixpath(thedir) 'stims.mat']);
                saveScript = g.saveScript;
                MTI = g.MTI2;
            end
        end

        function s = getstimscripttimestruct(obj, thedir)
            % GETSTIMSCRIPTTIMESTRUCT - Gets stimscript as stimscripttimestruct
            [ss, mti] = obj.getstimscript(thedir);
            s = stimscripttimestruct(ss, mti);
        end

        function tag = gettag(obj, dir_name)
            % GETTAG - Get tag(s) from a directory
            wholedir = [obj.getpathname() filesep dir_name];
            tagfilename = [wholedir filesep 'tags.txt'];

            if exist(tagfilename, 'file') == 2
                tag = vlt.file.loadStructArray(tagfilename);
            else
                tag = struct('tagname','','value','');
                tag = tag([]);
            end
        end

        function v = gettagvalue(obj, dir_name, name)
            % GETTAGVALUE - Get a value of a named tag
            v = [];
            tags = obj.gettag(dir_name);

            if ~isempty(tags)
                names = {tags.tagname};
                tf = strcmp(name, names);
                if any(tf)
                    indexes = find(tf);
                    v = tags(tf(1)).value;
                end
            end
        end

        function T = gettests(obj, name, ref)
            % GETTESTS - Returns the list of directories for name/ref
            g = obj.namerefind(obj.nameref_str, name, ref);

            if g > 0
                T = obj.nameref_str(g).listofdirs;
            else
                T = [];
            end
        end

        function b = hastag(obj, dir_name, tagname)
            % HASTAG - Returns TRUE if a given tagname is present
            tags = obj.gettag(dir_name);

            if ~isempty(tags)
                b = any(strcmp(tagname, {tags.tagname}));
            else
                b = 0;
            end
        end

        function b = isactive(obj, dirname)
            % ISACTIVE - Returns 1 if dirname is an active directory
            b = zeros(length(dirname), 1);
            if ischar(dirname)
                [~, g] = intersect(obj.active_dir_list, dirname);
                b = ~isempty(g);
            else
                for i = 1:length(dirname)
                    [~, g] = intersect(obj.active_dir_list, dirname{i});
                    b(i) = ~isempty(g);
                end
            end
        end

        function obj = neuter(obj, dir_or_list)
            % NEUTER - Disable directory without removing data
            if ~iscell(dir_or_list)
                dir_or_list = {dir_or_list};
            end

            for i = 1:numel(dir_or_list)
                dirpathhere = [obj.getpathname() filesep dir_or_list{i}];
                if ~exist(dirpathhere, 'dir')
                    error(['No such directory ' dirpathhere '.']);
                end
                reference_txt = [dirpathhere filesep 'reference.txt'];
                reference0_txt = [dirpathhere filesep 'reference0.txt'];
                if ~exist(reference_txt, 'file')
                    error(['No such file ' reference_txt '.']);
                end
                movefile(reference_txt, reference0_txt);
            end

            % Re-initialize the object
            obj = vlt.file.dirstruct(obj.getpathname());
        end

        function d = newtestdir(obj)
            % NEWTESTDIR - Returns a suitable new test directory name
            p = obj.getpathname();
            i = 1;
            while exist([p 't' sprintf('%.5d',i)], 'dir') == 7
                i = i + 1;
            end
            d = ['t' sprintf('%.5d',i)];
        end

        function addtag(obj, dir_name, tagname, value)
            % ADDTAG - Add a tag to a dirstruct directory
            wholedir = [obj.getpathname() filesep dir_name];
            tagfilename = [wholedir filesep 'tags.txt'];
            taglockfilename = [wholedir filesep 'tags-lock.txt'];

            newtag = struct('tagname',tagname,'value',value);

            if isvarname(tagname)
                [fid, key] = vlt.file.checkout_lock_file(taglockfilename, 30, 1);
                if fid > 0
                    try
                        tags = obj.gettag(dir_name);
                        if ~isempty(tags)
                            tf = find(strcmp(tagname, {tags.tagname}));
                            if ~isempty(tf)
                                tags(tf) = newtag;
                            else
                                tags(end+1) = newtag;
                            end
                        else
                            tags = newtag;
                        end
                        vlt.file.saveStructArray(tagfilename, tags);
                    catch ME
                        vlt.file.release_lock_file(taglockfilename, key);
                        rethrow(ME);
                    end
                    vlt.file.release_lock_file(taglockfilename, key);
                end
            else
                error(['Cannot add tag with requested tagname ' tagname ' to directory ' wholedir '; the tag name is not a valid Matlab variable name.']);
            end
        end

        function removetag(obj, dir_name, tagname)
            % REMOVETAG - Remove a tag from a dirstruct directory
            wholedir = [obj.getpathname() filesep dir_name];
            tagfilename = [wholedir filesep 'tags.txt'];
            taglockfilename = [wholedir filesep 'tags-lock.txt'];

            [fid, key] = vlt.file.checkout_lock_file(taglockfilename, 30, 1);
            if fid > 0
                try
                    tags = obj.gettag(dir_name);
                    if ~isempty(tags)
                        tf = find(strcmp(tagname, {tags.tagname}));
                        if ~isempty(tf)
                            tags(tf) = [];
                        end
                        if isempty(tags)
                            if exist(tagfilename, 'file')
                                delete(tagfilename);
                            end
                        else
                            vlt.file.saveStructArray(tagfilename, tags);
                        end
                    end
                catch ME
                    vlt.file.release_lock_file(taglockfilename, key);
                    rethrow(ME);
                end
                vlt.file.release_lock_file(taglockfilename, key);
            end
        end

        function saveexpvar(obj, vrbl_sev, name_sev, pres)
            % SAVEEXPVAR - Saves an experiment variable
            arguments
                obj
                vrbl_sev
                name_sev
                pres (1,1) logical = false
            end

            preserved_sev = pres;

            if isa(name_sev, 'char')
                vrbl_sev = {vrbl_sev};
                name_sev = {name_sev};
            end

            fn_sev = obj.getexperimentfile(1);
            fnlock_sev = [fn_sev '-lock'];

            [fid, key] = vlt.file.checkout_lock_file(fnlock_sev, 30, 1);

            if fid > 0
                try
                    if exist(fn_sev, 'file') == 2
                        warnstate_sev = warning('off');
                        doappend_sev = (exist(fn_sev, 'file') == 2);
                        warning(warnstate_sev);

                        for i = 1:length(name_sev)
                            a = [];
                            if preserved_sev
                                warnstate_sev = warning('off');
                                try
                                    l = load(fn_sev, name_sev{i}, '-mat');
                                catch
                                    l = struct();
                                end
                                warning(warnstate_sev);

                                if isempty(fieldnames(l))
                                    isafield_sev = 0;
                                else
                                    isafield_sev = isfield(l, name_sev{i});
                                end

                                if isafield_sev
                                    gf_sev = getfield(l, name_sev{i}); %#ok<GFLD>
                                    if isa(gf_sev, 'measureddata')
                                        a = getassociate(gf_sev, 1:numassociates(gf_sev));
                                        if isempty(a), a = []; end
                                    end
                                end
                            end

                            if ~isempty(a) && isa(vrbl_sev{i}, 'measureddata')
                                b = getassociate(vrbl_sev{i}, 1:numassociates(vrbl_sev{i}));
                                if isempty(b), b = []; end
                                a = [a b];
                                if ~isempty(b)
                                    vrbl_sev{i} = disassociate(vrbl_sev{i}, 1:numassociates(vrbl_sev{i}));
                                end
                                for j = 1:length(a)
                                    vrbl_sev{i} = associate(vrbl_sev{i}, a(j));
                                end
                            end
                            eval([name_sev{i} '=vrbl_sev{i};']);
                        end

                        if doappend_sev
                            save(fn_sev, name_sev{:}, '-append', '-mat');
                        else
                            save(fn_sev, name_sev{:}, '-mat');
                        end
                    else
                         % New file logic
                         for i = 1:length(name_sev)
                             eval([name_sev{i} '=vrbl_sev{i};']);
                         end
                         save(fn_sev, name_sev{:}, '-mat');
                    end
                catch ME
                    vlt.file.release_lock_file(fnlock_sev, key);
                    rethrow(ME);
                end
                vlt.file.release_lock_file(fnlock_sev, key);
            end
        end

        function deleteexpvar(obj, variablenametobedeleted, additionalvariables, additionalvariablenames, preserveassociates)
            % DELETEEXPVAR - Delete a variable from the experiment.mat file
            arguments
                obj
                variablenametobedeleted
                additionalvariables = {}
                additionalvariablenames = {}
                preserveassociates (1,1) logical = false
            end

            if isempty(variablenametobedeleted) && nargin < 3
                return;
            end

            if ischar(variablenametobedeleted)
                variablenametobedeleted = {variablenametobedeleted};
            end

            fn_sev = obj.getexperimentfile();

            if exist(fn_sev, 'file') == 2
                fnlock_sev = [fn_sev '-lock'];
                loops_sev = 0;
                while (exist(fnlock_sev, 'file') == 2) && loops_sev < 30
                    pause(rand);
                    loops_sev = loops_sev + 1;
                end

                if loops_sev == 30
                    error(['Could not control file ' fn_sev ': file is locked.']);
                end

                fid0_sev = fopen(fnlock_sev, 'w');
                if fid0_sev > 0
                    fclose(fid0_sev);
                else
                    error(['Could not open lock file at location ' fnlock_sev]);
                end

                try
                    data = load(fn_sev, '-mat');
                catch ME
                    delete(vlt.file.fixtilde(fnlock_sev));
                    error(['Could not read in variables from experiment.mat file ' fn_sev ', error is ' ME.message]);
                end

                variables_to_be_deleted = intersect(variablenametobedeleted, fieldnames(data));

                if ~isempty(variables_to_be_deleted)
                    data = rmfield(data, variables_to_be_deleted);
                end

                if isempty(variables_to_be_deleted) && nargin < 3
                    delete(vlt.file.fixtilde(fnlock_sev));
                    return;
                end

                if nargin > 2
                    for i = 1:length(additionalvariablenames)
                        if preserveassociates && isfield(data, additionalvariablenames{i})
                            myvar = getfield(data, additionalvariablenames{i}); %#ok<GFLD>
                            if isa(myvar, 'measureddata') && isa(additionalvariables{i}, 'measureddata')
                                myassoc = findassociate(myvar, '', '', '');
                                for j = 1:length(myassoc)
                                    [~, assoc_indexes] = findassociate(additionalvariables{i}, myassoc(j).type, '', '');
                                    additionalvariables{i} = disassociate(additionalvariables{i}, assoc_indexes);
                                    additionalvariables{i} = associate(additionalvariables{i}, myassoc(j));
                                end
                            end
                        end
                        data = setfield(data, additionalvariablenames{i}, additionalvariables{i}); %#ok<SFLD>
                    end
                end

                if ~isempty(fieldnames(data))
                    save(fn_sev, '-struct', 'data', '-mat');
                else
                    delete(fn_sev);
                end

                delete(vlt.file.fixtilde(fnlock_sev));
            else
                if nargin > 2
                    if ~isempty(additionalvariables)
                        obj.saveexpvar(additionalvariables, additionalvariablenames, preserveassociates);
                    end
                end
            end
        end

        function ncksds = setactive(obj, adirlist, append)
            % SETACTIVE - Sets the active directories
            arguments
                obj
                adirlist
                append (1,1) logical = false
            end

            if ischar(adirlist)
                thedirlist = {adirlist};
            else
                thedirlist = adirlist;
            end

            active_list = intersect(obj.dir_list, thedirlist);
            if append
                obj.active_dir_list = union(active_list, obj.active_dir_list);
            else
                obj.active_dir_list = active_list;
            end
            ncksds = obj;
        end

        function disp(obj)
            % DISP - Display the object
            disp(['dirstruct object; manages directory ' obj.getpathname()]);
        end
    end

    methods (Access = private)
        function ind = namerefind(~, nameref_str, name, ref)
            % NAMEREFIND - returns -1 if not there, or the index of the nameref pair
            ind = -1;
            for i = 1:length(nameref_str)
                if strcmp(nameref_str(i).name, name) && nameref_str(i).ref == ref
                    ind = i;
                    break;
                end
            end
        end

        function ind = typefind(~, autoextractlist, type)
            % TYPEFIND - returns -1 if not there, or the index of the nameref pair
            ind = -1;
            for i = 1:length(autoextractlist)
                if strcmp(autoextractlist(i).type, type)
                    ind = i;
                    break;
                end
            end
        end
    end
end
