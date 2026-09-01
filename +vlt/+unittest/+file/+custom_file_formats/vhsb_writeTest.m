classdef vhsb_writeTest < matlab.unittest.TestCase
% VHSB_WRITETEST - tests for the header vlt.file.custom_file_formats.vhsb_write derives
%
% The X_constantinterval flag is derived from the second difference of X. The
% test is a magnitude test, so it must be taken on abs(): a series whose
% interval shrinks has an all-negative second difference, and without abs() its
% max is negative, compares less than the tolerance, and the series is recorded
% as constant-interval when it is not (issue #145).
%
% That flag decides which branch vhsb_read takes for a windowed read: a
% constant-interval file has its sample labels computed from X_increment, so a
% wrongly flagged file returns the wrong range of samples even though the X
% values themselves are stored correctly and a full read is unaffected.
%

	properties
		testDir
		testFile
	end

	methods(TestMethodSetup)
		function createTestDir(testCase)
			testCase.testDir = tempname;
			mkdir(testCase.testDir);
			testCase.testFile = fullfile(testCase.testDir, 'series.vhsb');
		end
	end

	methods(TestMethodTeardown)
		function removeTestDir(testCase)
			if exist(testCase.testDir,'dir')
				rmdir(testCase.testDir,'s');
			end
		end
	end

	methods
		function h = writeAndReadHeader(testCase, x)
			x = x(:);
			y = (1:numel(x))';
			vlt.file.custom_file_formats.vhsb_write(testCase.testFile, x, y, 'use_filelock', 0);
			h = vlt.file.custom_file_formats.vhsb_readheader(testCase.testFile);
		end
	end

	methods(Test)

		function testShrinkingIntervalIsNotConstant(testCase)
			% the regression: intervals 1, 0.5, 0.25 are not a constant interval
			h = testCase.writeAndReadHeader([0; 1; 1.5; 1.75]);
			testCase.verifyEqual(double(h.X_constantinterval), 0, ...
				'A shrinking interval must not be flagged as constant.');
		end

		function testGrowingIntervalIsNotConstant(testCase)
			h = testCase.writeAndReadHeader([0; 0.25; 0.75; 1.75]);
			testCase.verifyEqual(double(h.X_constantinterval), 0, ...
				'A growing interval must not be flagged as constant.');
		end

		function testConstantIntervalIsConstant(testCase)
			h = testCase.writeAndReadHeader((0:0.25:2)');
			testCase.verifyEqual(double(h.X_constantinterval), 1, ...
				'An evenly spaced series must be flagged as constant.');
		end

		function testThreeOrFewerSamplesAreNotConstant(testCase)
			% MATLAB's guard is numel(x)>3, so 4 samples is the first case tested
			for n=1:3,
				h = testCase.writeAndReadHeader((0:0.25:0.25*(n-1))');
				testCase.verifyEqual(double(h.X_constantinterval), 0, ...
					['Fewer than four samples must not be flagged as constant (n=' int2str(n) ').']);
			end;
		end

		function testWindowedReadOfShrinkingSeries(testCase)
			% what the wrong flag actually broke: with X_constantinterval set,
			% vhsb_read computes sample labels from the median increment (0.5)
			% and returns only the last sample here instead of the last two
			x = [0; 1; 1.5; 1.75];
			testCase.writeAndReadHeader(x);
			[y,xread] = vlt.file.custom_file_formats.vhsb_read(testCase.testFile, 1.5, 1.75);
			testCase.verifyEqual(xread(:), [1.5; 1.75], 'AbsTol', 1e-12);
			testCase.verifyEqual(y(:), [3; 4], 'AbsTol', 1e-12);
		end

		function testFullReadRoundTripsShrinkingSeries(testCase)
			x = [0; 1; 1.5; 1.75];
			testCase.writeAndReadHeader(x);
			[y,xread] = vlt.file.custom_file_formats.vhsb_read(testCase.testFile, -Inf, Inf);
			testCase.verifyEqual(xread(:), x, 'AbsTol', 1e-12);
			testCase.verifyEqual(y(:), (1:4)', 'AbsTol', 1e-12);
		end

	end
end
