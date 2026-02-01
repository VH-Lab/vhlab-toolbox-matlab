function effectSizes = get_lme_effect_sizes(lme)
% GET_LME_EFFECT_SIZES Computes effect sizes for a Linear Mixed Effects model.
%
%   effectSizes = GET_LME_EFFECT_SIZES(lme) takes a fitted LinearMixedModel 
%   object and returns a structure containing the raw Beta, Cohen's d 
%   approximation, and Standardized Beta for each fixed effect term.
%
%   ERROR CONDITION:
%   This function checks for interaction terms (e.g., 'A:B'). If any are 
%   present, it throws an error as requested, because simple main effect 
%   calculations are misleading in the presence of interactions.
%
%   METHODS / FORMULAS:
%   1. Cohen's d Approximation:
%      Measures the shift in the response variable relative to the raw 
%      standard deviation of the data.
%      
%      Formula:  d = Beta / sigma_y
%
%      Where:
%        Beta    = The estimated fixed effect coefficient (Raw Estimate).
%        sigma_y = The standard deviation of the response variable (y).
%
%   2. Standardized Beta (Beta_std):
%      Measures the change in the outcome (in standard deviations) for a 
%      1 standard deviation change in the predictor.
%
%      Formula:  Beta_std = Beta * (sigma_x / sigma_y)
%
%      Where:
%        sigma_x = The standard deviation of the specific column in the 
%                  fixed effects design matrix corresponding to that term. 
%                  (For categorical variables, this is the SD of the 0/1 
%                  dummy vector).
%
%   INPUT:
%       lme - A fitted LinearMixedModel object (from fitlme).
%
%   OUTPUT:
%       effectSizes - A structure containing vectors for:
%           .TermNames   (Cell array of coefficient names)
%           .RawBeta     (The original estimates)
%           .CohensD     (The approximated Cohen's d)
%           .StdBeta     (The standardized coefficients)
%
%   Example:
%       lme = fitlme(tbl, 'ReactionTime ~ Drug + (1|Subject)');
%       es = get_lme_effect_sizes(lme);

    %% 1. Input Validation
    if ~isa(lme, 'LinearMixedModel')
        error('Input must be a LinearMixedModel object created by fitlme.');
    end

    %% 2. Check for Interactions
    % We look at the coefficient names. In MATLAB, interactions usually 
    % appear as 'Var1:Var2'.
    coeffNames = lme.CoefficientNames;
    
    % Check if any name contains a colon ':', implying an interaction
    if any(contains(coeffNames, ':'))
        error('This function does not handle interactions. Please simplify your model or calculate simple effects manually.');
    end

    %% 3. Retrieve Data and Design Matrix
    % Get the response variable standard deviation (sigma_y)
    yName = lme.ResponseName;
    % We access the data table stored inside the object
    if isprop(lme, 'Variables')
        allData = lme.Variables;
        yData = allData.(yName);
        % Remove NaNs if any, though fitlme usually handles this
        sigma_y = std(yData, 'omitnan');
    else
        error('Could not access variables from the LME object.');
    end

    % Get the Fixed Effects Design Matrix (X)
    % This matrix contains the actual columns used for regression,
    % including the column of 1s for intercept and 0/1s for dummy vars.
    X = designMatrix(lme, 'Fixed');
    
    % Get the estimates (Beta)
    [betaVector, ~] = fixedEffects(lme);
    
    %% 4. Calculate Effect Sizes
    numTerms = length(betaVector);
    
    % Pre-allocate
    cohensD = zeros(numTerms, 1);
    stdBeta = zeros(numTerms, 1);
    
    for i = 1:numTerms
        beta = betaVector(i);
        
        % Calculate sigma_x for this specific term
        % X(:, i) is the column of the design matrix for this coefficient
        sigma_x = std(X(:, i), 'omitnan');
        
        % --- Calculation 1: Cohen's d Approximation ---
        cohensD(i) = beta / sigma_y;
        
        % --- Calculation 2: Standardized Beta ---
        % Note: For the Intercept, sigma_x is 0 (std of a column of 1s),
        % so StdBeta will correctly be 0.
        stdBeta(i) = beta * (sigma_x / sigma_y);
    end

    %% 5. Pack into Structure
    effectSizes.TermNames = coeffNames';
    effectSizes.RawBeta = betaVector;
    effectSizes.CohensD = cohensD;
    effectSizes.StdBeta = stdBeta;

end