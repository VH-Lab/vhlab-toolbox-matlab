classdef test_lme_factorial_power < matlab.unittest.TestCase
    % TEST_LME_FACTORIAL_POWER - tests for vlt.stats.power.lme_factorial_power

    properties
        Tbl
    end

    methods (TestMethodSetup)
        function makeData(testCase)
            % 2 x 2 design: Condition between animals, Treatment within animals,
            % neurons nested in animals
            rng(2);
            rows = {};
            animal = 0;
            conditions = {'ctrl','sh'};
            treatments = {'GFP','DREADDs'};
            for c=1:2
                for a=1:4
                    animal = animal + 1;
                    animalEffect = randn*0.5;
                    for t=1:2
                        for n=1:2
                            neuronEffect = randn*0.5;
                            for k=1:5
                                rows(end+1,:) = {5 + animalEffect + neuronEffect + randn, ...
                                    sprintf('image%d',n+2*(t-1)), 1000+animal, conditions{c}, treatments{t}}; %#ok<AGROW>
                            end
                        end
                    end
                end
            end
            testCase.Tbl = cell2table(rows,'VariableNames',...
                {'Density','NeuronID','AnimalID','Condition','Treatment'});
        end
    end

    methods (Test)
        function testInteractionPower(testCase)
            results = vlt.stats.power.lme_factorial_power(testCase.Tbl,'Density',...
                {'Condition','Treatment'},{'AnimalID','NeuronID'},[3 6],[0 4],...
                'referenceCategories',{'ctrl','GFP'},'numSimulations',20,...
                'useParallel',false,'doPlot',false,'verbose',false);
            testCase.verifyEqual(size(results.powerMatrix),[2 2]);
            testCase.verifyEqual(results.test.term,'Condition:Treatment');
            testCase.verifyEqual(results.pilot.betweenFactors,{'Condition'});
            testCase.verifyEqual(results.effectPattern.EffectPattern,[0;0;0;1]);
            % a zero effect should rarely be significant; a large effect usually should be
            testCase.verifyLessThan(results.powerMatrix(2,1),0.3);
            testCase.verifyGreaterThan(results.powerMatrix(2,2),results.powerMatrix(2,1));
            testCase.verifyEqual(height(results.requiredSubjects),2);
        end

        function testContrastAndUnits(testCase)
            results = vlt.stats.power.lme_factorial_power(testCase.Tbl,'Density',...
                {'Condition','Treatment'},{'AnimalID','NeuronID'},4,2,...
                'referenceCategories',{'ctrl','GFP'},...
                'testContrast',["sh / GFP","sh / DREADDs"],'nUnitsPerSubject',3,'nObsPerUnit',2,...
                'numSimulations',10,'useParallel',false,'doPlot',false,'verbose',false);
            testCase.verifyEqual(results.test.type,'contrast');
            testCase.verifyEqual(numel(results.powerMatrix),1);
        end

        function testOneGroupingLevel(testCase)
            % with only subjects as random effects, nObsPerUnit sets observations per subject per cell
            results = vlt.stats.power.lme_factorial_power(testCase.Tbl,'Density',...
                {'Condition','Treatment'},{'AnimalID'},[3 5],[0 2],...
                'referenceCategories',{'ctrl','GFP'},'testTerm','Treatment','nObsPerUnit',4,...
                'numSimulations',10,'useParallel',false,'doPlot',false,'verbose',false);
            testCase.verifyEqual(size(results.powerMatrix),[2 2]);
            testCase.verifyEqual(numel(results.pilot.sigmas),2);
            testCase.verifyTrue(any(strcmp(results.requiredSubjects.Properties.VariableNames,...
                'nSubjectsPerGroupFor80Percent')));
        end
    end
end
