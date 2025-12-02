classdef dirstructTest < matlab.unittest.TestCase

    properties
        testDir
        ds
    end

    methods (TestMethodSetup)
        function setup(testCase)
            testCase.testDir = [tempname filesep];
            mkdir(testCase.testDir);
            testCase.addTeardown(@() rmdir(testCase.testDir, 's'));

            % Create some dummy data
            mkdir([testCase.testDir 't00001']);
            ref1 = struct('name', 'test', 'ref', 1, 'type', 'dummy');
            vlt.file.saveStructArray([testCase.testDir 't00001' filesep 'reference.txt'], ref1);

            mkdir([testCase.testDir 't00002']);
            ref2 = struct('name', 'test', 'ref', 2, 'type', 'dummy');
            vlt.file.saveStructArray([testCase.testDir 't00002' filesep 'reference.txt'], ref2);

            testCase.ds = vlt.file.dirstruct(testCase.testDir);
        end
    end

    methods (Test)
        function testConstructor(testCase)
            ds = testCase.ds;
            testCase.verifyClass(ds, 'vlt.file.dirstruct');
            % Check path normalization (simple check)
            % On windows/unix path separators might differ, but it should end with separator
            p = ds.getpathname();
            testCase.verifyTrue(p(end) == filesep);
        end

        function testUpdate(testCase)
            ds = testCase.ds;
            % Should have found 2 directories
            testCase.verifyEqual(length(ds.dir_list), 2);
            testCase.verifyTrue(any(strcmp('t00001', ds.dir_list)));
            testCase.verifyTrue(any(strcmp('t00002', ds.dir_list)));

            % Check namerefs
            nr = ds.getallnamerefs();
            testCase.verifyEqual(length(nr), 2);
            testCase.verifyEqual(nr(1).name, 'test');
            testCase.verifyEqual(nr(1).ref, 1);
        end

        function testTagging(testCase)
            ds = testCase.ds;

            % Add tag
            ds.addtag('t00001', 'mytag', 123);

            % Check tag
            tag = ds.gettag('t00001');
            testCase.verifyEqual(length(tag), 1);
            testCase.verifyEqual(tag.tagname, 'mytag');
            testCase.verifyEqual(tag.value, 123);

            testCase.verifyTrue(logical(ds.hastag('t00001', 'mytag')));

            val = ds.gettagvalue('t00001', 'mytag');
            testCase.verifyEqual(val, 123);

            % Remove tag
            ds.removetag('t00001', 'mytag');
            testCase.verifyFalse(logical(ds.hastag('t00001', 'mytag')));

            val = ds.gettagvalue('t00001', 'mytag');
            testCase.verifyEmpty(val);
        end

        function testGetTests(testCase)
            ds = testCase.ds;
            t = ds.gettests('test', 1);
            testCase.verifyTrue(iscell(t));
            testCase.verifyEqual(t{1}, 't00001');

            t = ds.gettests('test', 2);
            testCase.verifyEqual(t{1}, 't00002');

            t = ds.gettests('nonexistent', 1);
            testCase.verifyEmpty(t);
        end

        function testNewTestDir(testCase)
            ds = testCase.ds;
            d = ds.newtestdir();
            % Since t00001 and t00002 exist, next should be t00003
            testCase.verifyEqual(d, 't00003');
        end

        function testNeuter(testCase)
            ds = testCase.ds;
            % Neuter t00001
            ds = ds.neuter('t00001');

            % Should now only have 1 active directory in list (t00002)
            % Wait, neuter re-runs constructor, so update is called.
            % But t00001/reference.txt is moved to reference0.txt, so it shouldn't be picked up.

            testCase.verifyEqual(length(ds.dir_list), 1);
            testCase.verifyEqual(ds.dir_list{1}, 't00002');

            % Check file existence
            testCase.verifyTrue(exist([testCase.testDir 't00001' filesep 'reference0.txt'], 'file') == 2);
            testCase.verifyFalse(exist([testCase.testDir 't00001' filesep 'reference.txt'], 'file') == 2);
        end

        function testSaveExpVar(testCase)
             ds = testCase.ds;

             % Create experiment file (implicitly done by getexperimentfile(1) inside saveexpvar if using dirstruct logic?)
             % Actually saveexpvar calls getexperimentfile(ds, 1) which creates it.

             myVar = struct('a', 1);
             ds.saveexpvar(myVar, 'myVar');

             expFile = ds.getexperimentfile();
             testCase.verifyTrue(exist(expFile, 'file') == 2);

             loaded = load(expFile, '-mat');
             testCase.verifyTrue(isfield(loaded, 'myVar'));
             testCase.verifyEqual(loaded.myVar.a, 1);

             % Test delete
             ds.deleteexpvar('myVar');
             loaded = load(expFile, '-mat');
             testCase.verifyFalse(isfield(loaded, 'myVar'));
        end

    end
end
