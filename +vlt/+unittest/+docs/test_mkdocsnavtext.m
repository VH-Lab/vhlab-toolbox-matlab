classdef test_mkdocsnavtext < matlab.unittest.TestCase
    methods (Test)
        function testNormalTitle(testCase)
            out.title = 'NormalTitle';
            out.path = 'path/to/normal.md';
            t = vlt.docs.mkdocsnavtext(out, 0);

            % Check output format.
            % Expected: '- NormalTitle: ''path/to/normal.md'''
            testCase.verifyTrue(contains(t, '- NormalTitle:'), 'Normal title should not be quoted');
        end

        function testTitleWithAtSign(testCase)
            out.title = '@ClassTitle';
            out.path = 'path/to/class.md';
            t = vlt.docs.mkdocsnavtext(out, 0);

            % Check output format.
            % Expected: '- ''@ClassTitle'': ''path/to/class.md'''
            testCase.verifyTrue(contains(t, '- ''@ClassTitle'':'), 'Title starting with @ should be quoted');
        end

        function testNested(testCase)
            out.title = 'Parent';
            out.path(1).title = '@Child';
            out.path(1).path = 'path/to/child.md';
            t = vlt.docs.mkdocsnavtext(out, 0);

            % Check parent (normal)
            testCase.verifyTrue(contains(t, '- Parent:'), 'Parent title should be normal');

            % Check child (quoted)
            testCase.verifyTrue(contains(t, '- ''@Child'':'), 'Child title starting with @ should be quoted');
        end

        function testEmptyTitle(testCase)
            out.title = '';
            out.path = 'path/to/empty.md';
            t = vlt.docs.mkdocsnavtext(out, 0);

            % Should not error and handle empty title gracefully
            testCase.verifyTrue(contains(t, '- :'), 'Empty title handled');
        end
    end
end
