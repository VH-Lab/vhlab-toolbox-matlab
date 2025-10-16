classdef test_log < matlab.unittest.TestCase
    % TEST_LOG - test for vlt.app.log
    %
    properties
        test_dir
    end

    methods (TestClassSetup)
        function create_test_dir(testCase)
            testCase.test_dir = [tempdir filesep 'test_log_dir'];
            if exist(testCase.test_dir, 'dir')
                rmdir(testCase.test_dir, 's');
            end
            mkdir(testCase.test_dir);
        end
    end

    methods (TestClassTeardown)
        function remove_test_dir(testCase)
            if exist(testCase.test_dir, 'dir')
                rmdir(testCase.test_dir, 's');
            end
        end
    end

    methods (Test)
        function test_constructor_defaults(testCase)
            % TEST_CONSTRUCTOR_DEFAULTS - test constructor with default arguments
            log_obj = vlt.app.log();
            testCase.verifyEqual(log_obj.system_logfile, [userpath filesep 'system.log']);
            testCase.verifyEqual(log_obj.error_logfile, [userpath filesep 'error.log']);
            testCase.verifyEqual(log_obj.debug_logfile, [userpath filesep 'debug.log']);
            testCase.verifyEqual(log_obj.system_verbosity, 1.0);
            testCase.verifyEqual(log_obj.error_verbosity, 1.0);
            testCase.verifyEqual(log_obj.debug_verbosity, 1.0);
            testCase.verifyEqual(log_obj.log_name, '');
            testCase.verifyEqual(log_obj.log_error_behavior, 'warning');
        end

        function test_constructor_name_value(testCase)
            % TEST_CONSTRUCTOR_NAME_VALUE - test constructor with name-value arguments
            system_log = [testCase.test_dir filesep 'system.log'];
            error_log = [testCase.test_dir filesep 'error.log'];
            debug_log = [testCase.test_dir filesep 'debug.log'];
            log_obj = vlt.app.log(...
                'system_logfile', system_log, ...
                'error_logfile', error_log, ...
                'debug_logfile', debug_log, ...
                'system_verbosity', 2.0, ...
                'error_verbosity', 2.0, ...
                'debug_verbosity', 2.0, ...
                'log_name', 'my_log', ...
                'log_error_behavior', 'error');
            testCase.verifyEqual(log_obj.system_logfile, system_log);
            testCase.verifyEqual(log_obj.error_logfile, error_log);
            testCase.verifyEqual(log_obj.debug_logfile, debug_log);
            testCase.verifyEqual(log_obj.system_verbosity, 2.0);
            testCase.verifyEqual(log_obj.error_verbosity, 2.0);
            testCase.verifyEqual(log_obj.debug_verbosity, 2.0);
            testCase.verifyEqual(log_obj.log_name, 'my_log');
            testCase.verifyEqual(log_obj.log_error_behavior, 'error');
        end

        function test_touch(testCase)
            % TEST_TOUCH - test that log files are created
            system_log = [testCase.test_dir filesep 'system_touch.log'];
            error_log = [testCase.test_dir filesep 'error_touch.log'];
            debug_log = [testCase.test_dir filesep 'debug_touch.log'];
            log_obj = vlt.app.log(...
                'system_logfile', system_log, ...
                'error_logfile', error_log, ...
                'debug_logfile', debug_log);
            log_obj.touch();
            testCase.verifyTrue(exist(system_log, 'file')==2);
            testCase.verifyTrue(exist(error_log, 'file')==2);
            testCase.verifyTrue(exist(debug_log, 'file')==2);
        end

        function test_msg(testCase)
            % TEST_MSG - test writing messages to the log files
            system_log = [testCase.test_dir filesep 'system_msg.log'];
            error_log = [testCase.test_dir filesep 'error_msg.log'];
            debug_log = [testCase.test_dir filesep 'debug_msg.log'];
            log_obj = vlt.app.log(...
                'system_logfile', system_log, ...
                'error_logfile', error_log, ...
                'debug_logfile', debug_log, ...
                'log_name', 'test_log');

            % Test system message
            log_obj.msg('system', 1, 'This is a system message.');
            log_content = fileread(system_log);
            testCase.verifyMatches(log_content, '\[test_log\] SYSTEM This is a system message.');

            % Test error message
            log_obj.msg('error', 1, 'This is an error message.');
            log_content = fileread(error_log);
            testCase.verifyMatches(log_content, '\[test_log\] ERROR This is an error message.');

            % Test debug message
            log_obj.msg('debug', 1, 'This is a debug message.');
            log_content = fileread(debug_log);
            testCase.verifyMatches(log_content, '\[test_log\] DEBUG This is a debug message.');
        end

        function test_seterrorbehavior(testCase)
            % TEST_SETERRORBEHAVIOR - test the seterrorbehavior method
            log_obj = vlt.app.log();
            log_obj.seterrorbehavior('error');
            testCase.verifyEqual(log_obj.log_error_behavior, 'error');
            log_obj.seterrorbehavior('nothing');
            testCase.verifyEqual(log_obj.log_error_behavior, 'nothing');
        end
    end
end