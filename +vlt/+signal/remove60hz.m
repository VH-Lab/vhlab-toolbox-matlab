function data_out = remove60hz(data_in, samplerate, varargin)
% REMOVE60HZ remove 60Hz noise
%
%   DATA_OUT = REMOVE60HZ(DATA_IN, SAMPLERATE)
%
%   Removes 60Hz noise via filtering with the methods and 
%   parameters described below. DATA_IN must be a vector.
%
%   User beware: check the output of this function carefully
%   with your data, to be sure that it doesn't produce garbage.
%   High frequencies (like spikes) can often be disturbed by
%   certain methods employed here ('sgolay'), so this is best
%   done on low frequency data (for example, membrane potential
%   with spikes removed).
%
%   The method and parameters of the function can be modified
%   with name/value pairs:
%
%   Parameter (default):           |  Description 
%   --------------------------------------------------------------
%   METHOD ('sgolay')              |  If 'sgolay':
%                                  |      Use Savitzky-Golay filter
%                                  |      Relies on SOGOLAYFILT
%                                  |  If 'cheby1':
%                                  |      Use chebychev1 type filter
%                                  |      Relies on CHEBY1 and FILTFILT
%                                  |      (Signal Processing Toolbox)
%                                  |  If 'ellip':
%                                  |      Use elliptical filter
%                                  |      Relies on ELLIP and FILTFILT
%                                  |  If 'ellip+sgolay', then the algorithm
%                                  |      uses a blend of the 'ellip' and 
%                                  |      'sgolay' methods. The signal is 
%                                  |      first high-pass filtered above
%                                  |      'ellipsgolay_high'. This high-pass
%                                  |      signal is then removed from the data,
%                                  |      and the remaining low-pass signal
%                                  |      is passed through the standard
%                                  |      'sgolay' mode. Finally, the high
%                                  |      frequencies that were identified
%                                  |      in the 'high-pass' filter are added back.
%   sgolay_freq (60)               |  For 'sgolay', the frequency to remove.
%                                  |      
%   Stop ([55 65])                 |  For 'cheby1' and 'ellip', the
%                                  |      stop filter frequencies
%   R (0.5)                        |  For 'cheby1' and 'ellip', R
%                                  |      decibles of peak-
%                                  |      to-peak ripple in passband
%   Rs (20)                        |  For 'ellip', at least Rs decibles
%                                  |      of attentuation
%                                         in the stop band
%   Order (3)                      |  For 'cheby1' and 'ellip', the filter
%                                  |      order
%   ellipsgolay_high (65)          |  For 'ellip+sgolay', the high pass frequency
%   
%   
%                             
%   If you get NaN for your output data, try reducing the filter order.
%
%   Contributions: Wes Alford, Steve Van Hooser

if min(size(data_in))~=1, error(['DATA_IN must be a vector.']); end;

	% assign defaults
METHOD = 'sgolay';
sgolay_freq = 60;
Stop = [55 65];
Order = 3;
R = 0.5;
Rs = 20;
ellipsgolay_high = 65;

assign(varargin{:});  % make user modifications

switch(METHOD),
	case 'sgolay', % Wes's code
		t_in = 0:1/samplerate:(length(data_in)-1)*(1/samplerate);
		sample_60Hz = sgolay_freq*round(samplerate/sgolay_freq); % prepare to resample so that sampling rate is evenly divisible by 60
		t_resample = 0:1/sample_60Hz:(length(data_in)-1)*(1/samplerate);
		data_resample = interp1(t_in,data_in,t_resample,'linear');
		data_filtered = sgolayfilt(data_resample,1,sample_60Hz/sgolay_freq); % filter
		data_out = interp1(t_resample,data_filtered,t_in,'linear');
		if length(data_out)<length(data_in), data_out(end+1) = data_in(end); end; % possibly 1 sample short
		if isnan(data_out(end)), data_out(end) = data_in(end); end; % possible NaN in interp1
	case 'cheby1',
		[b,a] = cheby1(Order,R,Stop/[0.5 * samplerate],'stop'),
		data_out = filtfilt(b,a,data_in);
	case 'ellip',
		[b,a] = ellip(Order,R,Rs,Stop/[0.5 * samplerate],'stop'),
		data_out = filtfilt(b,a,data_in);
	case 'ellip+sgolay',
		[b,a] = ellip(Order,R,Rs,ellipsgolay_high/[0.5*samplerate],'high');
		data_high = filtfilt(b,a,data_in);
		data_out = remove60hz(data_in-data_high,samplerate,varargin{:},'METHOD','sgolay');
		data_out = data_out(:) + data_high(:); % make both column vectors
	otherwise,
		error(['Unknown filter method ' METHOD '.']);
end;

	%return a row or column vector, whatever the user input
if (size(data_in,2)>size(data_in,1) & size(data_out,2)<size(data_out,1)) || ...
	(size(data_in,2)<size(data_in,1) & size(data_out,2)>size(data_out,1))
	data_out = data_out';
end;
