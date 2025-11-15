classdef loadStructArrayTest < matlab.unittest.TestCase
    properties
        testFileWithHeader
        testFileWithoutHeader
    end

    methods (TestMethodSetup)
        function createTestFiles(testCase)
            % File 1: With a header including only valid field names for deprecated test
            testCase.testFileWithHeader = [tempname '.txt'];
            fid = fopen(testCase.testFileWithHeader, 'wt');
            fprintf(fid, 'first_name\tlast_name\tvalue\n');
            fprintf(fid, 'John\tSmith\t123\n');
            fprintf(fid, 'Jane\tDoe\t456.7\n');
            fclose(fid);

            % File 2: Without a header, for testing provided fields
            testCase.testFileWithoutHeader = [tempname '.txt'];
            fid = fopen(testCase.testFileWithoutHeader, 'wt');
            fprintf(fid, 'A\tB\t10\n');
            fprintf(fid, 'C\tD\t20\n');
            fclose(fid);
        end
    end

    methods (TestMethodTeardown)
        function removeTestFiles(testCase)
            if exist(testCase.testFileWithHeader, 'file')
                delete(testCase.testFileWithHeader);
            end
            if exist(testCase.testFileWithoutHeader, 'file')
                delete(testCase.testFileWithoutHeader);
            end
        end
    end

    methods (Test)
        function test_load_with_header(testCase)
            % NOTE: This test assumes the deprecated function does NOT sanitize
            % header names. Therefore, the test file uses only valid names.
            s = loadStructArray(testCase.testFileWithHeader);

            testCase.verifyEqual(size(s), [1 2]);

            expectedFields = {'first_name', 'last_name', 'value'};
            testCase.verifyEqual(fieldnames(s)', expectedFields);

            testCase.verifyEqual(s(1).first_name, 'John');
            testCase.verifyEqual(s(1).last_name, 'Smith');
            testCase.verifyEqual(s(1).value, 123);

            testCase.verifyEqual(s(2).first_name, 'Jane');
            testCase.verifyEqual(s(2).last_name, 'Doe');
            testCase.verifyEqual(s(2).value, 456.7);
        end

        function test_load_with_provided_fields(testCase)
            fields = {'fieldA', 'fieldB', 'fieldC'};
            s = loadStructArray(testCase.testFileWithoutHeader, fields);

            testCase.verifyEqual(size(s), [1 2]);
            testCase.verifyEqual(fieldnames(s)', fields);

            testCase.verifyEqual(s(1).fieldA, 'A');
            testCase.verifyEqual(s(1).fieldB, 'B');
            testCase.verifyEqual(s(1).fieldC, 10);

            testCase.verifyEqual(s(2).fieldA, 'C');
            testCase.verifyEqual(s(2).fieldB, 'D');
            testCase.verifyEqual(s(2).fieldC, 20);
        end

        function test_load_empty_file(testCase)
            emptyFile = [tempname '.txt'];
            fclose(fopen(emptyFile, 'w'));
            s = loadStructArray(emptyFile);
            testCase.verifyTrue(isempty(s));
            delete(emptyFile);
        end

        function test_load_nonexistent_file(testCase)
            nonexistentFile = 'nonexistent.txt';
            testCase.verifyError(@() loadStructArray(nonexistentFile), '');
        end
    end
end
