classdef tone

	properties
		value
	end % properties

	methods
		function obj = tone(input)
			% TONE - create a new musical tone object
			%
			% OBJ = TONE (INPUT)
			%
			% Input can be the following:
			%    An integer, where 0 denotes C4 (middle C).
			%      1 denotes C4#, 2 denotes D4, etc.
			%      -1 denotes B3, -2 denotes A3#, etc.
			%    A character string of 2 or 3 characters,
			%     where the first character (A-G) indicates the
			%     letter of the tone, the second character is the
			%     number of the tone, and the optional third 
			%     character is a sharp '#' or flat 'b'.
			%     
				if vlt.data.isint(input),
					obj.value = input;
				elseif ischar(input),
					obj.value = vlt.music.tone.char2num(input);
				else,
					error(['INPUT must be integers or characters.']);
				end;
		end; % tone() constructor

		function c = char(tone_obj)
			% CHAR - return the character description of a tone
			%
			% C = CHAR(TONE_OBJ)
			% 
			% Return the character notation of a tone object.
			%
			% Example:
			%   tone_obj = vlt.music.tone(0);
			%   c = tone_obj.char % will be 'C4'
			%
				if numel(tone_obj) == 1,
					c = vlt.music.tone.num2char(tone_obj.value);
				else,
					for i=1:numel(tone_obj),
						c{i} = tone_obj(i).char();
					end;
				end;
		end; % char

		function t = major(tone_obj)
			% MAJOR - return the tones that make up the natural major scale of a tone (Ionian mode)
			% 
			% T = MAJOR(TONE_OBJ)
			%
			% Return an array of tone objects that correspond to the major
			% scale of a tone. This is also known as the Ionian mode.
			%
			% Example:
			%  a = tone('A3'); % tone is A3
			%  m = a.major();
			%  m.char() % print the tones
			%
				t = tone_obj.scale([ 0 2 2 1 2 2 2 1 ]);
		end % major()

		function t = minor(tone_obj)
			% MINOR - return the tones that make up the natural minor scale of a tone
			% 
			% T = MINOR(TONE_OBJ)
			%
			% Return an array of tone objects that correspond to the natural minor
			% scale of a tone. (Aeolian mode.)
			%
			% Example:
			%  a = tone('A3'); % tone is A3
			%  m = a.minor();
			%  m.char() % print the tones
			%
				t = tone_obj.scale([0 2 1 2 2 1 2 2]);
		end % minor()

		function s = scale(tone_obj, intervals)
			% SCALE - return a scale generated with a certain array of tone intervals
			%
			% S = SCALE(TONE_OBJ, INTERVALS)
			%
			% Returns an array of tone objects that correspond to the specified intervals.
			% 
			% Example:
			%  c = tone('C4'); % middle C
			%  m = c.scale([0 2 2 1 2 2 2 1]); % natural major scale
			%  m.char()

				if numel(tone_obj)>1,
					error(['This function is only useable with a single vlt.music.tone object.']);
				end;
				tone_adds = cumsum(intervals);
				
				s = vlt.music.tone(tone_obj.value+tone_adds(1));
				for i=2:numel(tone_adds),
					s(end+1) = vlt.music.tone(tone_obj.value+tone_adds(i));
				end;
		end; % scale


	end % methods

	methods (Static)
		function N = char2num(input)
			% CHAR2NUM - convert a character description of a tone into a tone number
			%
			% N = CHAR2NUM(INPUT)
			%
			% Given a character input of a note (e.g., 'A3#', 'C4', 'G2b'), returns the
			% tone number N. 
			%	
			% The character input should consist of a letter describing the note ('A'-'G'),
			% an integer describing the level of the note (0, 1, 9), and a trailing character
			% of '#' (sharp) or 'b' (flat) if necessary.
			%
			% The output N is a tone number, which is a signed integer. 'C4' is 0, and each tone is an
			% integer step up or down. For example, 'B3' is -1, 'A3#' is -2, 'C4#' is 1, etc.
			%
				if ~ischar(input),
					error(['INPUT must be a character array.']);
				end;
				if numel(input)~=2 | numel(input)~=3,
					error(['INPUT must be 2 or 3 characters.']);
				end;

				letter = upper(input(1));

				level = str2int(input(2));

				switch letter,
					case 'A',
						n = -3;
					case 'B',
						n = -1;
					case 'C',
						n = 0;
					case 'D',
						n = 2;
					case 'E',
						n = 4;
					case 'F',
						n = 5;
					case 'G',
						n = 7;
					otherwise,
						error(['Unknown tone letter ' letter '.']);
				end;

				n = n + (level-4)*12;

				if numel(input)==3,
					sharpflat = input(3);
					switch sharpflat,
						case '#',
							n = n + 1;
						case 'b',
							n = n - 1;
						otherwise,
							error(['Unknown sharp/flat #/b character: ' sharpflat '.']);
					end;
				end;

		end; % char2num()

		function c = num2char(num)
			% NUM2CHAR - return a character description of a music tone
			%
			% C = NUM2CHAR(NUM)
			% 
			% Return the character description of a musical tone with number NUM.
			%
			% 0 is middle C ('C4'), -1 is 'B3', -2 is 'A3#', etc.
			%
			% The character array will always bs 2-3 characters long. The first character
			% is the letter, the second character is a digit specifying the level 0..9, and
			% the third character (if necessary) will be a sharp.
			%
				level = 4 + fix(num/12);
				if level>9,
					error(['Only levels up to 9 are supported.']);
				end;
				letter_array = ['CCDDEFFGGAAB'];
				sharp_flat =   [' # #  # # # '];
				array_pos = 1+mod(num,12);
				c = strtrim([letter_array(array_pos) int2str(level) sharp_flat(array_pos)]);
			
		end; % num2char()
	end % static methods
end % classdef
