function next_frame = visual_stim_row_correlator(frame_data, correlator,sign)
% VISUAL_STIM_ROW_CORRELATOR - Compute the next visual stimulus frame for a given correlator
%
%  NEXT_FRAME = VISUAL_STIM_ROW_CORRELATOR(FRAME_DATA, CORRELATOR, SIGN)
%
%  Given a frame of visual stimulus data that consists of -1's and 1s
%  (FRAME_DATA), then a new frame (NEXT_FRAME) of -1's and 1s is created
%  such that the correlation between the new frame and the old frame is
%  as described in CORRELATOR (see below).
%
%  The algorithm operates on the rows of the stimulus, so that if the
%  stimulus frame has many rows, each row will be operated on independently.
%
%  CORRELATOR: A number that indicates which correlator to use
%     0: 2-point leftward correlator
%     1: 2-point rightward correlator
%     2: 3-point converging leftward correlator
%     3: 3-point converging rightward correlator
%     4: 3-point diverging leftward correlator
%     5: 3-point diverging rightward correlator
%
%  SIGN: the sign of the correlator; should the product be -1 or 1?
%
%  For a graphical depiction of these correlators, see Clark, Fitzgerald, and Ales et al.,
%  Nature Neuroscience 2014 (in particular, Supplementary Figure 4)
%
%  Example: Compute 10 frames for a single row, using a leftward 2-point correlator (sign 1)
%      correlator = 0;
%      corelator_sign = 1;
%      row_data = [ 1 1 -1 1 -1 -1 1 1]; % made up data
%      for i=1:10,
%         row_data(i+1,:) = visual_stim_row_correlator(row_data(i,:),correlator,correlator_sign);
%      end;
%      row_data,
%    


  % WARNING WARNING WARNING
  % WARNING WARNING WARNING 
  %  Some users may expect this file to exactly match the function used by
  %  GLIDERGRIDSTIM (NewStim Library). See the embedded version in GLIDERGRIDSTIM/GETGRIDVALUES.

[R,C] = size(frame_data);
next_frame = frame_data;
if ~(sign==-1 | sign==1),
	error(['SIGN must be -1 or 1.']);
end;

switch correlator,
	case 0 % 2-point leftward correlator
		K = [2 C+1]; % indexes that should be multiplied
		edit_position = 1; % to which point does the above correlation apply?
		start_pos = 0; % where to start running the correlator
		stop_pos = C-2; % where to stop running the correlator
		edit_range = [1:C-1];
		new_range = [C];
		diverging = 0;

	case 1 % 2-point rightward correlator
		K = [1 C+2]; % indexes that should be multiplied
		edit_position = 2; % to which point does the above correlation apply?
		start_pos = 0;
		stop_pos = C-2;
		edit_range = [2:C];
		new_range = [1];
		diverging = 0;

	case 2 % 3-point leftward converging correlator
		K = [1 2 C+1];
		edit_position = 1;
		start_pos = 0;
		stop_pos = C-2;
		edit_range = [1:C-1];
		new_range = C;
		diverging = 0;

	case 3 % 3-point rightward converging correlator
		K = [1 2 C+2];
		edit_position = 2;
		start_pos = 0;
		stop_pos = C-2;
		edit_range = 2:C;
		new_range = 1;
		diverging = 0;

	case 4 % 3-point leftward diverging correlator
		K = [2 C+1 C+2];
		edit_position = 1;
		start_pos = 0;
		stop_pos = C-2;
		edit_range = 1:C-1;
		new_range = C;
		diverging = -1;

	case 5 % 3-point rightward diverging correlator
		K = [1 C+1 C+2];
		edit_position = 2;
		start_pos = 0;
		stop_pos = C-2;
		edit_range = 2:C;
		new_range = 1;
		diverging = 1;

end; % switch correlator

N = stop_pos - start_pos + 1; % total number of points to examine for each correlator

K_all = repmat(K,N,1) + repmat( (start_pos:stop_pos)', 1, length(K));

for r=1:R,
	% step 1, generate a new frame randomly; then we'll calculate what needs to be flipped
	% we'll represent the current frame and the next frame in a 2 column matrix
	% we will restrict ourselves to editing points that are eligible to be changed
	v = [frame_data(r,:); -1+2*(rand(1,size(frame_data,2))>0.5)]';
	if diverging==0,
		corrs = prod(v(K_all),2);
		flip = (edit_position-1) + find(corrs~=sign);
		ind = intersect(flip,edit_range);
		% step 2: update values that don't match the correation structure needed
		v(ind,2) = -v(ind,2);
	else,
		if diverging>0, 
			start = 1;
			stop = size(K_all,1);
		else,
			start = size(K_all,1);
			stop = 1;
		end;

		for k=start:diverging:stop
			corr = prod(v(K_all(k,:)),2);
			if corr~=sign,
				v(edit_position-1+k,2) = -v(edit_position-1+k,2);
			end;
		end;
	end;
	next_frame(r,:) = v(:,2)';
end;


