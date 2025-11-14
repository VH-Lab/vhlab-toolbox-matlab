classdef fileobjTest < matlab.unittest.TestCase

    properties
        testDir
        testFile
        fo % file object
    end

    methods(TestMethodSetup)
        function setup(testCase)
            testCase.testDir = tempname;
            mkdir(testCase.testDir);
            testCase.testFile = fullfile(testCase.testDir, 'testfile.bin');
            testCase.fo = vlt.file.fileobj('fullpathfilename', testCase.testFile);
        end
    end

    methods(TestMethodTeardown)
        function teardown(testCase)
            if ~isempty(testCase.fo) && isvalid(testCase.fo)
                delete(testCase.fo); % This should also close the file
            end
            if exist(testCase.testDir, 'dir')
                rmdir(testCase.testDir, 's');
            end
        end
    end

    methods(Test)
        function test_constructor_and_properties(testCase)
            testCase.verifyEqual(testCase.fo.fullpathfilename, testCase.testFile);
            testCase.verifyEqual(testCase.fo.fid, -1);
            testCase.verifyEqual(testCase.fo.permission, 'r');
        end

        function test_fopen_fclose(testCase)
            testCase.fo.fopen('w');
            testCase.verifyGreaterThan(testCase.fo.fid, 2); % fid should be valid
            testCase.fo.fclose();
            testCase.verifyEqual(testCase.fo.fid, -1);
        end

        function test_fwrite_fread(testCase)
            data_out = uint8([10, 20, 30, 40, 50]);

            testCase.fo.fopen('w');
            count_w = testCase.fo.fwrite(data_out, 'uint8');
            testCase.fo.fclose();
            testCase.verifyEqual(count_w, numel(data_out));

            testCase.fo.fopen('r');
            [data_in, count_r] = testCase.fo.fread(Inf, 'uint8');
            testCase.fo.fclose();

            testCase.verifyEqual(count_r, numel(data_out));
            testCase.verifyEqual(data_in', data_out);
        end

        function test_fseek_ftell_frewind(testCase)
            data_out = 'Hello World';
            testCase.fo.fopen('w');
            testCase.fo.fwrite(data_out);
            testCase.fo.fclose();

            testCase.fo.fopen('r');
            testCase.fo.fseek(6, 'bof');
            testCase.verifyEqual(testCase.fo.ftell(), 6);

            world = testCase.fo.fread(5, 'char=>char')';
            testCase.verifyEqual(world, 'World');

            testCase.fo.frewind();
            testCase.verifyEqual(testCase.fo.ftell(), 0);
            testCase.fo.fclose();
        end

        function test_feof(testCase)
            data_out = [1 2 3];
            testCase.fo.fopen('w');
            testCase.fo.fwrite(data_out, 'double');
            testCase.fo.fclose();

            testCase.fo.fopen('r');
            testCase.verifyFalse(logical(testCase.fo.feof()));
            testCase.fo.fread(3, 'double');
            testCase.verifyTrue(logical(testCase.fo.feof()));
            testCase.fo.fclose();
        end

        function test_fprintf_fgetl_fgets(testCase)
            line1 = 'First line';
            line2 = 'Second line';

            testCase.fo.fopen('w');
            testCase.fo.fprintf('%s\n%s\n', line1, line2);
            testCase.fo.fclose();

            testCase.fo.fopen('r');
            l1 = testCase.fo.fgetl();
            l2_with_newline = testCase.fo.fgets();
            testCase.fo.fclose();

            testCase.verifyEqual(l1, line1);
            testCase.verifyEqual(l2_with_newline, sprintf([line2 '\n']));
        end

        function test_fileparts(testCase)
            [p, n, e] = fileparts(testCase.fo);
            [expected_p, expected_n, expected_e] = fileparts(testCase.testFile);
            testCase.verifyEqual(p, expected_p);
            testCase.verifyEqual(n, expected_n);
            testCase.verifyEqual(e, expected_e);
        end
    end
end
