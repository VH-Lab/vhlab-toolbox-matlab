function g = listofvars(classname)

% VLT.DATA.LISTOFVARS - List variables of a specific class in the base workspace
%
%   VARLIST = vlt.data.listofvars(CLASSNAME)
%
%   Returns a cell array of strings containing the names of all variables in
%   the base workspace that are of the class CLASSNAME.
%
%   The 'ans' variable is excluded from the list.
%
%   Example:
%       a = 5; b = 'hello'; c = [1 2 3];
%       double_vars = vlt.data.listofvars('double'); % returns {'a', 'c'}
%
%   See also: WHOS, EVALIN, ISA
%

g = {}; g_ = 0;
w = evalin('base','whos');

for i=1:length(w),
        if (strcmp(w(i).name,'ans')==0)&...
             evalin('base',['isa(' w(i).name ',''' classname ''')']),
                g_ = g_ + 1;
                g{g_} = w(i).name;
        end;
end;

