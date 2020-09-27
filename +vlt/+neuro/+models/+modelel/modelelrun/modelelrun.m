function [modelrunstruct,varsout] = modelrun(modelel, varargin)
% MODELELRUN - Run a set of model elements modelel
%
%  MODELELRUNSTRUCT = vlt.neuro.models.modelel.modelelrun.modelelrun(MODELEL)
%
%  Runs a model that is composed of a list of modelel. The default parameters
%  of the model can be altered by calling the form:
%
%  MODELELRUNSTRUCT = vlt.neuro.models.modelel.modelelrun.modelelrun(MODELEL, PARAM1NAME, PARAM1VALUE, ...)
%
%  If a second output variable is provided, then the variables that are
%  stored to disk (if Directory isn't empty) are also returned in VARS.
%  The values are long doubles in a NUMBER_OF_VARIABLES by NUMBER_OF_STEPS
%  array.
%  [MODELELRUNSTRUCT,VARS] = vlt.neuro.models.modelel.modelelrun.modelelrun(MODELEL, PARAM1NAME, PARAM1VALUE, ...)
%  
% MODELRUN structure elements/model parameters (defaults in parenthesis):
% -------------------------------------------------------------------
% RandomSeed (structure)            |  Info on Matlab version and random seed
%   .version                        |     Output of the ver('Matlab') command
%   .RandomSeed                     |     The random seed
% Model_Initial_Structure (modelel) |  Initial structure of the model
% Model_Final_Structure (modelel)   |  Final structure of the model
% Steps (100)                       |  Number of steps to run
% Directory ('')                    |  Directory where data is to be
%                                   |   saved ('' for none)
% Comment ('')                      |  Comment on what this simulation is
% Variables ({})                    |  Variables that are saved
%                                   |      These are a cell list with one variable per row.
%                                   |      The variable should be specified as a subfield of
%                                   |      the variable modelrunstruct. For example, to grab
%                                   |      the time ('T') parameter of the first element, use
%                                   |      {'modelrunstruct.Model_Initial_Structure(1).T'}.
%                                   |      In the second column, one can optionally provide a 
%                                   |      variable name.
%                                   |      These variables are written to the file
%                                   |      variables.bin, 1 long double per variable,
%                                   |      one variable per time step
% Verbose (10000)                   |  Prints a comment every N steps; use Inf to disable
% UseExecutable (0)                 |  Uses an external function

%  See also: MODELEL

 % get the default random stream seed value

RandomSeed.version = ver('Matlab');

if str2num(RandomSeed.version.Version)<7.14,
	myStream = RandStream.getDefaultStream;
else,
	myStream  = RandStream.getGlobalStream;
end;

RandomSeed.RandomSeed = myStream.State;

Model_Initial_Structure = modelel;
Steps = 100;
Model_Final_Structure = modelel;
Directory = '';
Comment = '';
Variables= [];
Verbose = 10000;

UseExecutable = 0;

vlt.data.assign(varargin{:});

modelrunstruct = struct('RandomSeed',RandomSeed,...
			'Model_Initial_Structure', Model_Initial_Structure, ...
			'Model_Final_Structure', Model_Final_Structure, ...
			'Steps', Steps, ...
			'Directory', Directory, ...
			'Comment', Comment, ...
			'Variables', {Variables}, ...
			'Verbose', Verbose);

if UseExecutable,
	modelel_out = vlt.neuro.models.modelel.modelelrun.modelel_convertforc(modelrunstruct.Model_Initial_Structure, Variables);
	base_matlab_dir = vlt.path.pathstr2cellarray(userpath);
	modelel_out_string = vlt.data.struct2mlstr(modelel_out);
	% write text output file here
	infile = [base_matlab_dir{1} filesep 'Modelel_model.txt'],
	vlt.file.cellstr2text(infile,{modelel_out_string});
	outfile = [base_matlab_dir{1} filesep 'Modelel_runout.txt'],

	out_string = ['! /Users/vanhoosr/Google\ Drive/shared/ian_shared/Modelel2 ' infile ' ' outfile ' -steps ' int2str(modelrunstruct.Steps)];
	eval(out_string);
end;

if nargout > 1,
	varsout = zeros(length(modelrunstruct.Variables),Steps);
end;

if 0, % dont do this now, as this isn't the right way to do it
 % set the random number stream state
v = ver('Matlab');
if str2num(v.Version)<7.14,
	RandStream.setDefaultStream(modelrunstruct.RandomSeed.RandomSeed);
else,
	RandStream.setGlobalStream(modelrunstruct.RandomSeed.RandomSeed);
end;
end;

for n=1:modelrunstruct.Steps,
	if mod(n,modelrunstruct.Verbose)==0,
		disp(['vlt.neuro.models.modelel.modelelrun.modelelrun: currently on step ' int2str(n) ' of ' int2str(modelrunstruct.Steps) '.']);
	end;
	currentmodel = modelrunstruct.Model_Final_Structure;
	for i=1:length(modelrunstruct.Model_Final_Structure),
		model = currentmodel(i).model;
		if ~isempty(model),
			modeltype = model.type;
			currentmodel(i) = eval([modeltype ...
				'_step(modelrunstruct.Model_Final_Structure(i),modelrunstruct.Model_Final_Structure);']);
		end;
	end;
	modelrunstruct.Model_Final_Structure = currentmodel;
	% save variables
	for i=1:length(modelrunstruct.Variables)
		if nargout>1,
			varsout(i,n) = eval(Variables{i});
		end;
		if ~isempty(modelrunstruct.Directory),
			% log to disk
		end;
	end;
end;

