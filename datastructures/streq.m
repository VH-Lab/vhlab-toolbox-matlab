function b = streq(S1,S2,thewc)

% STREQ(S1,S2 [,WC])
%
%  Returns 1 if S1 and S2 are equal, and 0 otherwise.  The wildcard '*' may be
%  used in S2, and then STREQ will return 1 if S1 matches the wildcard criteria.
%  If the user wants to use a different wildcard character other than '*',
%  a different wildcard character can be given in WC.

  % this can probably be sped up
b = 1;

if nargin==3, wc = thewc; else, wc = '*'; end;
ll = 0;
if isempty(S2)&~isempty(S1),b = 0; return;end;
inds = find(S2==wc); 
if isempty(inds), b = strcmp(S1,S2); return; end;
if inds(1)~=1,inds = [0 inds]; end;
if inds(end)~=length(S2),inds = [inds length(S2)+1]; end;
for i=1:length(inds)-1,
     stri = (inds(i)+1):(inds(i+1)-1);
     if ~isempty(stri), % else is **
       l = findstr(S1,S2( (inds(i)+1):(inds(i+1)-1)));
       if isempty(l), b=0; return;
       else,
         L = ll<l; k=find(L);
         if isempty(k), b=0;return;
         else, ll = l(k(1));
         end;
       end;
     end;
end;
