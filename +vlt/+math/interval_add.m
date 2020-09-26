function i_out = interval_add(i_in, i_add)
% INTERVAL_ADD - add intervals 
% 
% I_OUT = INTERVAL_ADD(I_IN, I_ADD)
%
% Given a matrix of intervals I_IN = [T1_0 T1_1; T2_0 T2_1 ; ... ] 
% where T is increasing (that is, where T(i)_0 > T(i-1)_0 and Ti_0<Ti_1 for all i),
% produce another matrix of intervals I_OUT that includes the interval I_ADD = [S0 S1].
% I_IN can be empty.
%
% Examples:
%    i_out = interval_add([0 3],[3 6])  % yields [ 0 6]
%    i_out = interval_add([0 2],[3 4])  % yields [ 0 2; 3 4]
%    i_out = interval_add([0 10],[0 2]) % yields [ 0 10]
%

 % let's start out assuming we can operate on the intervals in order; we probably can

  % we have many possibilities that might require addition in [ti_0 ti_1]:
  %    s0 might be inside [ti_0,ti_1). 
  %        If s1 is also in (ti_0,ti_1], then we do nothing, it is subsumed already
  %        If s1 is bigger than ti_1, then we need to extend the interval to s1
  %    s0 might be less than ti_0 but s1 might be inside (ti_0,ti_1]
  %        In this case, we need to make the interval [ s0 ti_1 ]
  %    s0 might be less than ti_0 but s1 might be greater than ti_1
  %        In this case, this interval needs to be [s0 s1]
  %    s0 and s1 might be between intervals (not in any [ti_0,ti1])
  %        In this case, need to add the interval to the list in the right spot
 
 % some error checking

if isempty(i_in),
	i_out = i_add;
	return;
end;

if isempty(i_add),
	i_out = i_in;
	return;
end;

if numel(i_add)~=2,
	error(['The interval to add must be a 2-element vector.']);
end;

if any(i_in(:,2)-i_in(:,1) <= 0)
	error(['In all intervals ti_0 must be less than ti_1']);
end;

if any (i_in(2:end,1)-i_in(1:end-1,2) <= 0),
	error(['In all input intervals I_IN, ti_1 must be greater than than t(i-1)_2']);
end

s0 = i_add(1);
s1 = i_add(2);

if s1-s0 <=0,
	error(['S0 must be less than S1']);
end;

s0_inside = (s0 >= i_in(:,1)) & (s0 < i_in(:,2));
s1_inside = (s1 >= i_in(:,1)) & (s1 < i_in(:,2));

s0_less_and_s1_greater = (s0 < i_in(:,1)) & (s1 > i_in(:,2));
s0_less_and_s1_inside  = (s0 < i_in(:,1)  & s1_inside);

i_out = [];

did_something = 0;

for i=1:size(i_in,1),
	out_here = [ i_in(i,:) ];
	if s0_inside(i),
		if s1_inside(i), % take no action but note that we took no action
			did_something = i;
		else, % extend to s1
			out_here = [ i_in(i,1) s1 ];
			did_something = i;
		end;
	elseif s1_inside(i),
		out_here = [ s0 i_in(i,2) ];
		did_something = i;
	elseif s0_less_and_s1_greater(i), % we have to add whole thing
		out_here = [s0 s1];
		did_something = i;
	else, % we leave it alone
	end;
	i_out = [i_out; out_here];
end

if did_something==0,
	% need to add in this interval and sort the list
	i_out = [i_out; s0 s1];
	[dummy,indexes] = sort(i_out(:,1));
	i_out = [ i_out(indexes,:) ]; % sort it properly
	did_something = indexes(end);
end;

% we need to check to make sure that we didn't create overlapping intervals
if did_something>1, % if it was the first one where we did something, then we could not have created overlapping intervals
	if i_out(did_something-1,2)>=i_out(did_something,1), % need to merge
		i_out(did_something-1,2) = i_out(did_something,2);
		i_out(did_something,:) = []; % delete that row
	end
end


