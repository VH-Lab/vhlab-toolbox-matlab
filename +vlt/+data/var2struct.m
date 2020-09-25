function output = var2struct(varargin)
% VAR2STRUCT - Export variable(s) to a structure
%
%  OUTPUT = VAR2STRUCT('NAME1', 'NAME2', ...)
%
%  Saves local workspace variables as a structure.
%  
%  Each variable is added a field to the structure OUTPUT.
%
%  Example:
%     Imagine your workspace has 3 variables, A=5, B=6, C=7;
%    
%     output = var2struct('a','b')
%
%       produces
%
%     output = 
%        a: 5
%        b: 6
%

for i=1:length(varargin)
	myval = evalin('caller',varargin{i});
	eval(['output.' varargin{i} '=myval;']);
	%output = setfield(output,varargin{i},evalin('caller',varargin{i}));
        % why does the line above not work, you ask?  Because when output is 
        % you can write output.a = 5; but you can't write
        % output = setfield(output,'a',5); without getting an error
end;

