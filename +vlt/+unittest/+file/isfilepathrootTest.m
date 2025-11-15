classdef isfilepathrootTest < matlab.unittest.TestCase
    methods (Test)
        function testIsFilePathRoot(testCase)
            % Test cases that should be true if the path starts with '/'
            % This is true for both unix and pc
            testCase.verifyTrue(logical(vlt.file.isfilepathroot('/home/user/doc.txt')), 'Test absolute Unix path');
            testCase.verifyTrue(logical(vlt.file.isfilepathroot('/')), 'Test Unix root');

            % Test cases that should be false on all platforms
            testCase.verifyFalse(logical(vlt.file.isfilepathroot('home/user/doc.txt')), 'Test relative Unix path');
            testCase.verifyFalse(logical(vlt.file.isfilepathroot('doc.txt')), 'Test simple file name');
            testCase.verifyFalse(logical(vlt.file.isfilepathroot('../doc.txt')), 'Test relative path with ..');

            % Test Windows-specific paths
            if ispc
                testCase.verifyTrue(logical(vlt.file.isfilepathroot('C:\Users\user\doc.txt')), 'Test absolute Windows path');
                testCase.verifyTrue(logical(vlt.file.isfilepathroot('C:\')), 'Test Windows root');
                testCase.verifyFalse(logical(vlt.file.isfilepathroot('Users\user\doc.txt')), 'Test relative Windows path');
            else % on Unix
                % The function should return false for these on Unix
                testCase.verifyFalse(logical(vlt.file.isfilepathroot('C:\Users\user\doc.txt')), 'Test absolute Windows path on Unix');
                testCase.verifyFalse(logical(vlt.file.isfilepathroot('C:\')), 'Test Windows root on Unix');
                testCase.verifyFalse(logical(vlt.file.isfilepathroot('Users\user\doc.txt')), 'Test relative Windows path on Unix');
            end
        end
    end
end
