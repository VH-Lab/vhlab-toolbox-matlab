classdef vcard2matTest < matlab.unittest.TestCase
    % Tests for the deprecated vcard2mat function

    properties
        tempDir
        vcfFile
    end

    methods (TestMethodSetup)
        function createTempVcfFile(testCase)
            % Create a temporary directory and a VCF file for testing
            testCase.tempDir = tempname;
            mkdir(testCase.tempDir);
            testCase.vcfFile = fullfile(testCase.tempDir, 'test.vcf');

            vcfContent = {
                'BEGIN:VCARD'
                'VERSION:3.0'
                'N:Doe;John;;;'
                'FN:John Doe'
                'ORG:ACME Inc.'
                'TITLE:CEO'
                'TEL;TYPE=WORK,VOICE:(123) 456-7890'
                'EMAIL;TYPE=PREF,INTERNET:john.doe@acme.com'
                'END:VCARD'
                'BEGIN:VCARD'
                'VERSION:3.0'
                'N:Smith;Jane;;;'
                'FN:Jane Smith'
                'NOTE:This is a note that continues'
                '  on the next line.'
                'END:VCARD'
            };

            fid = fopen(testCase.vcfFile, 'w');
            for i = 1:numel(vcfContent)
                fprintf(fid, '%s\r\n', vcfContent{i});
            end
            fclose(fid);
        end
    end

    methods (TestMethodTeardown)
        function removeTempVcfFile(testCase)
            % Clean up the temporary directory and file
            if exist(testCase.tempDir, 'dir')
                rmdir(testCase.tempDir, 's');
            end
        end
    end

    methods (Test)
        function testBasicVCardParsing(testCase)
            % Test basic parsing of a VCF file with two entries

            % Important: Call the deprecated function, not vlt.file.vcard2mat
            v = vcard2mat(testCase.vcfFile);

            % Verify the number of cards parsed
            testCase.verifyEqual(numel(v), 2, 'Should parse two vCards.');

            % --- Verify the first vCard (John Doe) ---
            v_john = v{1};

            % Check simple fields - note the quirky char array quoting behavior
            testCase.verifyEqual(v_john.VERSION, 3.0, 'VERSION field is incorrect for John.');
            testCase.verifyEqual(v_john.N, 'Doe;John;;;', 'N field is incorrect for John.');
            testCase.verifyEqual(v_john.FN, 'John Doe', 'FN field is incorrect for John.');
            testCase.verifyEqual(v_john.ORG, 'ACME Inc.', 'ORG field is incorrect for John.');
            testCase.verifyEqual(v_john.TITLE, 'CEO', 'TITLE field is incorrect for John.');

            % Check complex fields (with parameters)
            testCase.verifyTrue(isfield(v_john, 'TEL'), 'TEL field should exist for John.');
            testCase.verifyTrue(iscell(v_john.TEL), 'TEL field should be a cell array.');
            testCase.verifyEqual(numel(v_john.TEL), 1, 'TEL cell array should have one element.');
            tel_struct = v_john.TEL{1};
            testCase.verifyEqual(tel_struct.TYPE, {'WORK,VOICE'}, 'TEL TYPE parameter is incorrect.');
            testCase.verifyEqual(tel_struct.data, '(123) 456-7890', 'TEL data is incorrect.');

            testCase.verifyTrue(isfield(v_john, 'EMAIL'), 'EMAIL field should exist for John.');
            email_struct = v_john.EMAIL{1};
            testCase.verifyEqual(email_struct.TYPE, {'PREF,INTERNET'}, 'EMAIL TYPE parameter is incorrect.');
            testCase.verifyEqual(email_struct.data, 'john.doe@acme.com', 'EMAIL data is incorrect.');

            % --- Verify the second vCard (Jane Smith) ---
            v_jane = v{2};

            testCase.verifyEqual(v_jane.VERSION, 3.0, 'VERSION field is incorrect for Jane.');
            testCase.verifyEqual(v_jane.N, 'Smith;Jane;;;', 'N field is incorrect for Jane.');
            testCase.verifyEqual(v_jane.FN, 'Jane Smith', 'FN field is incorrect for Jane.');

            % Check multi-line field
            expectedNote = 'This is a note that continues on the next line.';
            testCase.verifyEqual(v_jane.NOTE, expectedNote, 'Multi-line NOTE field was not parsed correctly.');
        end

        function testNonExistentFile(testCase)
            % Test that the function errors gracefully for a non-existent file
            nonExistentFile = fullfile(testCase.tempDir, 'no_such_file.vcf');
            testCase.verifyError(@() vcard2mat(nonExistentFile), ...
                '', 'Should error when the VCF file does not exist.');
        end
    end
end
