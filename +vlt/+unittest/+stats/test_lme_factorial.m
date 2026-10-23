classdef test_lme_factorial < matlab.unittest.TestCase
    % TEST_LME_FACTORIAL - tests for vlt.stats.lme_factorial and vlt.stats.plot_lme_factorial

    properties
        Tbl
    end

    methods (TestMethodSetup)
        function makeData(testCase)
            % 2 x 2 design: Condition is between animals, Treatment is within animals,
            % neurons are nested in animals, several observations per neuron.
            % Neuron names are reused across animals to check the nesting.
            rng(1);
            rows = {};
            animal = 0;
            conditions = {'ctrl','sh'};
            treatments = {'GFP','DREADDs'};
            for c=1:2
                for a=1:5
                    animal = animal + 1;
                    animalEffect = randn*0.5;
                    for t=1:2
                        for n=1:3
                            neuronEffect = randn*0.5;
                            for k=1:6
                                density = 5 + 1*(c==2) + 0.5*(t==2) + 1*(c==2 && t==2) + ...
                                    animalEffect + neuronEffect + randn*0.5;
                                rows(end+1,:) = {density, sprintf('image%d',n+3*(t-1)), ...
                                    1000+animal, conditions{c}, treatments{t}}; %#ok<AGROW>
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
        function testFit(testCase)
            [lme,newTable,stats] = vlt.stats.lme_factorial(testCase.Tbl,'Density',...
                {'Condition','Treatment'},{'AnimalID','NeuronID'},...
                'referenceCategories',{'ctrl','GFP'});
            testCase.verifyClass(lme,'LinearMixedModel');
            testCase.verifyEqual(height(newTable),height(testCase.Tbl));
            testCase.verifyEqual(stats.groupVarNames,{'AnimalID','NeuronID_in_AnimalID'});
            % 10 animals x 6 neurons each are distinct units even though names repeat
            testCase.verifyEqual(numel(categories(newTable.NeuronID_in_AnimalID)),60);
            testCase.verifyEqual(stats.factorLevels{1},{'ctrl','sh'});
            testCase.verifyEqual(stats.factorLevels{2},{'GFP','DREADDs'});
            testCase.verifyEqual(height(stats.cellMeans),4);
            testCase.verifyEqual(stats.cellMeans.Label,["ctrl / GFP";"ctrl / DREADDs";"sh / GFP";"sh / DREADDs"]);
            testCase.verifyEqual(stats.cellMeans.n_AnimalID,[5;5;5;5]);
            testCase.verifyEqual(stats.cellMeans.n_NeuronID,[15;15;15;15]);
            testCase.verifyTrue(any(strcmp(stats.anovaTable.Term,'Condition:Treatment')));
            testCase.verifyEqual(height(stats.contrasts),4); % simple effects in a 2x2
            testCase.verifyTrue(all(stats.contrasts.pAdjusted>=stats.contrasts.pValue));
            % cell mean estimates should be close to the raw cell means
            for c=1:4
                raw = mean(newTable.Density(stats.cellIndexes{c}));
                testCase.verifyEqual(stats.cellMeans.Estimate(c),raw,'AbsTol',0.5);
            end
        end

        function testEffects(testCase)
            [~,~,stats] = vlt.stats.lme_factorial(testCase.Tbl,'Density',...
                {'Condition','Treatment'},{'AnimalID','NeuronID'},...
                'referenceCategories',{'ctrl','GFP'});
            e = stats.effects;
            testCase.verifyEqual(e.Term,["Condition";"Treatment";"Condition:Treatment"]);
            testCase.verifyEqual(e.Definition(3),"(sh / DREADDs - sh / GFP) - (ctrl / DREADDs - ctrl / GFP)");
            testCase.verifyEqual(e.Definition(1),"sh - ctrl; averaged over Treatment");
            testCase.verifyEqual(stats.effectsUnits,'units of Y');
            % cell means are ctrl/GFP, ctrl/DREADDs, sh/GFP, sh/DREADDs
            m = stats.cellMeans.Estimate;
            testCase.verifyEqual(e.Estimate(3),(m(4)-m(3))-(m(2)-m(1)),'AbsTol',1e-10);
            testCase.verifyEqual(e.Estimate(1),mean(m(3:4))-mean(m(1:2)),'AbsTol',1e-10);
            testCase.verifyEqual(e.Estimate(2),mean(m([2 4]))-mean(m([1 3])),'AbsTol',1e-10);
            % the simulated interaction is 1
            testCase.verifyEqual(e.Estimate(3),1,'AbsTol',1);
            testCase.verifyTrue(all(e.CILower<e.Estimate & e.Estimate<e.CIUpper));
            % with effects coding, the p-values match the ANOVA
            for t=1:3
                testCase.verifyEqual(e.pValue(t),stats.anovaTable.pValue(strcmp(stats.anovaTable.Term,e.Term(t))),...
                    'RelTol',1e-6);
            end
            % the estimates do not depend on the coding
            [~,~,statsRef] = vlt.stats.lme_factorial(testCase.Tbl,'Density',...
                {'Condition','Treatment'},{'AnimalID','NeuronID'},...
                'referenceCategories',{'ctrl','GFP'},'dummyVarCoding','reference');
            testCase.verifyEqual(statsRef.effects.Estimate,e.Estimate,'AbsTol',1e-6);
            % log fit reports ratios
            [~,~,statsLog] = vlt.stats.lme_factorial(testCase.Tbl,'Density',...
                {'Condition','Treatment'},{'AnimalID','NeuronID'},'logData',true);
            testCase.verifyEqual(statsLog.effects.Ratio,10.^statsLog.effects.Estimate,'RelTol',1e-12);
            % and it can be skipped
            [~,~,statsNone] = vlt.stats.lme_factorial(testCase.Tbl,'Density',...
                {'Condition','Treatment'},{'AnimalID','NeuronID'},'computeEffects',false);
            testCase.verifyEqual(height(statsNone.effects),0);
        end

        function testPlannedContrasts(testCase)
            % cells: ctrl/GFP, ctrl/DREADDs, sh/GFP, sh/DREADDs
            contrasts = struct('name', {'C1','C2','C3','S1'}, ...
                'weights', {[-1 1 0 0], [-1 0 1 0], [1 -1 -1 1], [0 0 -1 1]}, ...
                'direction', {'greater','greater','less','none'}, ...
                'margin', {NaN, NaN, NaN, 100}, ...
                'family', {'', '', '', 'S'});
            [~,~,stats] = vlt.stats.lme_factorial(testCase.Tbl,'Density',...
                {'Condition','Treatment'},{'AnimalID','NeuronID'},...
                'referenceCategories',{'ctrl','GFP'},'plannedContrasts',contrasts);
            pc = stats.plannedContrasts;
            m = stats.cellMeans.Estimate;
            testCase.verifyEqual(pc.Name, ["C1";"C2";"C3";"S1"]);
            testCase.verifyEqual(pc.Estimate(1), m(2)-m(1), 'AbsTol', 1e-10);
            testCase.verifyEqual(pc.Estimate(2), m(3)-m(1), 'AbsTol', 1e-10);
            % the interaction contrast matches stats.effects
            testCase.verifyEqual(pc.Estimate(3), stats.effects.Estimate(3), 'AbsTol', 1e-10);
            testCase.verifyEqual(pc.pValue(3), stats.effects.pValue(3), 'RelTol', 1e-8);
            testCase.verifyEqual(pc.Prediction(3), "less");
            % a huge margin makes the equivalence test pass
            testCase.verifyTrue(pc.Equivalent(4));
            testCase.verifyTrue(all(isnan(pc.pEquivalence(1:3))));
            % contrasts without a family are not adjusted
            testCase.verifyEqual(pc.pAdjusted(1:3), pc.pValue(1:3));
            % the simulated interaction is +1, so a prediction of < 0 is not supported
            testCase.verifyFalse(pc.Supported(3));
        end

        function testSubjectMeans(testCase)
            [~,newTable,stats] = vlt.stats.lme_factorial(testCase.Tbl,'Density',...
                {'Condition','Treatment'},{'AnimalID','NeuronID'},...
                'referenceCategories',{'ctrl','GFP'});
            means = vlt.stats.lme_factorial_subject_means(newTable,stats);
            % 10 animals, each in 2 cells; 3 neurons per animal per cell; 6 segments per neuron
            testCase.verifyEqual(numel(means.subjects),10);
            testCase.verifyEqual(height(means.subjectMeans),20);
            testCase.verifyEqual(height(means.unitMeans),60);
            testCase.verifyTrue(all(means.subjectMeans.nUnits==3));
            testCase.verifyTrue(all(means.subjectMeans.nObs==18));
            testCase.verifyEqual(means.scale,'linear');
            % a subject mean is the mean of its unit means
            r = 1;
            units = means.unitMeans(means.unitMeans.Cell==means.subjectMeans.Cell(r) & ...
                means.unitMeans.Subject==means.subjectMeans.Subject(r),:);
            testCase.verifyEqual(means.subjectMeans.Mean(r),mean(units.Mean),'AbsTol',1e-12);
        end

        function testSuperplotAndPaired(testCase)
            [lme,newTable,stats] = vlt.stats.lme_factorial(testCase.Tbl,'Density',...
                {'Condition','Treatment'},{'AnimalID','NeuronID'},...
                'referenceCategories',{'ctrl','GFP'});
            f = figure('Visible','off');
            testCase.addTeardown(@() close(f));
            [h,info] = vlt.stats.plot_lme_superplot(lme,newTable,stats,'yLabel','Density',...
                'titleText','SuperPlot');
            testCase.verifyNotEmpty(h);
            testCase.verifyEqual(size(info.subjectColors),[10 3]);
            testCase.verifyFalse(any(isnan(info.subjectMeans.x)));
            clf(f);
            [h,info] = vlt.stats.plot_lme_paired(lme,newTable,stats,'yLabel','Density');
            testCase.verifyNotEmpty(h);
            testCase.verifyEqual(info.panels,["ctrl";"sh"]);
            testCase.verifyEqual(info.nWithBoth,[5;5]);
            testCase.verifyEqual(info.nSubjects,[5;5]);
        end

        function testRankAndLog(testCase)
            [~,~,stats] = vlt.stats.lme_factorial(testCase.Tbl,'Density',...
                {'Condition','Treatment'},{'AnimalID','NeuronID'},'rankOrder',true);
            testCase.verifyEqual(stats.transform,'rank');
            [~,~,stats] = vlt.stats.lme_factorial(testCase.Tbl,'Density',...
                {'Condition','Treatment'},{'AnimalID','NeuronID'},'logData',true);
            testCase.verifyEqual(stats.transform,'log10');
            testCase.verifyTrue(any(strcmp(stats.cellMeans.Properties.VariableNames,'EstimateOriginalUnits')));
        end

        function testPlot(testCase)
            [lme,newTable,stats] = vlt.stats.lme_factorial(testCase.Tbl,'Density',...
                {'Condition','Treatment'},{'AnimalID','NeuronID'},...
                'referenceCategories',{'ctrl','GFP'});
            f = figure('Visible','off');
            testCase.addTeardown(@() close(f));
            [h,plotInfo] = vlt.stats.plot_lme_factorial(lme,newTable,stats,'yLabel','Density');
            testCase.verifyNotEmpty(h);
            testCase.verifyEqual(numel(plotInfo.xCenter),60);
            testCase.verifyEqual(size(plotInfo.cellBoundaries),[4 2]);
        end
    end
end
