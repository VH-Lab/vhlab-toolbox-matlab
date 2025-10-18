classdef cache < handle
% cache - Cache class
%
% 

	properties (SetAccess=protected,GetAccess=public)
		maxMemory % The maximum memory, in bytes, that can be consumed by an CACHE before it is emptied
		replacement_rule % The rule to be used to replace entries when memory is exceeded ('FIFO','LIFO','error', etc)
		table  % The variable that has the data and metadata for the cache
	end % properties

	properties (SetAccess=protected,GetAccess=private)
	end


	methods
		
		function cache_obj = cache(options)
			% CACHE - create a new NDI cache handle
			%
			% CACHE_OBJ = vlt.data.cache(...)
			%
			% Creates a new vlt.data.cache object. Additional arguments can be specified as
			% name value pairs:
			%
			% Parameter (default)         | Description
			% ------------------------------------------------------------
			% maxMemory (100e6)           | Max memory for cache, in bytes (100MB default)
			% replacement_rule ('fifo')   | Replacement rule (see CACHE/SET_REPLACEMENT_RULE
			%
			% Note that the cache is not 'secure', any function can query the data added.
			%
			% See also: vlt.data.namevaluepair
				arguments
					options.maxMemory (1,1) double = 100e6;
					options.replacement_rule (1,:) char = 'fifo';
				end

				disp('DEBUG (cache constructor): Start');
				cache_obj.table = vlt.data.emptystruct('key','type','timestamp','priority','bytes','data');
				cache_obj.maxMemory = options.maxMemory;
				cache_obj = set_replacement_rule(cache_obj, options.replacement_rule);
				disp('DEBUG (cache constructor): End. Cache contents:');
				disp(cache_obj.table);
		end % cache creator

		function cache_obj = set_replacement_rule(cache_obj, rule)
			% SET_REPLACEMENT_RULE - set the replacement rule for an CACHE object
			%
			% CACHE_OBJ = SET_REPLACEMENT_RULE(CACHE_OBJ, RULE)
			%
			% Sets the replacement rule for a vlt.data.cache object to be used when a new entry
			% would exceed the allowed memory. The rule may be one of the following strings
			% (case is insensitive and will be stored lower case):
			%
			% Rule            | Description
			% ---------------------------------------------------------
			% 'fifo'          | First in, first out; discard oldest entries first.
			% 'lifo'          | Last in, first out; discard newest entries first.
			% 'error'         | Don't discard anything, just produce an error saying cache is full
				disp('DEBUG (set_replacement_rule): Start');
				therules = {'fifo','lifo','error'};
				if any(strcmpi(rule,therules)),
					cache_obj.replacement_rule = lower(rule);
				else,
					error(['Unknown replacement rule requested: ' rule '.']);
				end
				disp('DEBUG (set_replacement_rule): End. Cache contents:');
				disp(cache_obj.table);
		end % set_replacement_rule

		function cache_obj = add(cache_obj, key, type, data, priority)
			% ADD - add data to an NDI.CACHE
			%
			% CACHE_OBJ = ADD(CACHE_OBJ, KEY, TYPE, DATA, [PRIORITY])
			%
			% Adds DATA to the CACHE_OBJ that is referenced by a KEY and TYPE.
			% If desired, a PRIORITY can be added; items with greatest PRIORITY will be
			% deleted last.
			%
				disp('DEBUG (add): Start');
				if nargin < 5,
					priority = 0;
				end

				% before we reorganize anything, make sure it will fit
				s = whos('data');
				if s.bytes > cache_obj.maxMemory,
					error(['This variable is too large to fit in the cache; cache''s maxMemory exceeded.']);
				end

				newentry = vlt.data.emptystruct('key','type','timestamp','priority','bytes','data');
				newentry(1).key = key;
				newentry(1).type = type;
				newentry(1).timestamp = now; % serial date number
				newentry(1).priority = priority;
				newentry(1).bytes = s.bytes;
				newentry(1).data = data;

				total_memory = cache_obj.bytes() + s.bytes;
				disp(['DEBUG (add): Current bytes: ' num2str(cache_obj.bytes()) ', New item bytes: ' num2str(s.bytes) ', Total memory: ' num2str(total_memory) ', Max memory: ' num2str(cache_obj.maxMemory)]);
				if total_memory > cache_obj.maxMemory, % it doesn't fit
					disp(['DEBUG (add): Memory limit exceeded. Rule: ' cache_obj.replacement_rule]);
					if strcmpi(cache_obj.replacement_rule,'error'),
						error(['Cache is too full too accommodate the new data; error was requested rather than replacement.']);
					end
					freespaceneeded = total_memory - cache_obj.maxMemory;
					disp(['DEBUG (add): Freeing ' num2str(freespaceneeded) ' bytes.']);
					cache_obj = cache_obj.freebytes(freespaceneeded, newentry);
				end

				% now there's room
				cache_obj.table(end+1) = newentry;
				disp('DEBUG (add): End. Cache contents:');
				disp(cache_obj.table);
		end % add

		function cache_obj = remove(cache_obj, index_or_key, type, varargin)
			% REMOVE - remove data from an NDI.CACHE
			%
			% CACHE_OBJ = REMOVE(CACHE_OBJ, KEY, TYPE, ...)
			%   or
			% CACHE_OBJ = REMOVE(CACHE_OBJ, INDEX, [],  ...)
			%
			% Removes the data at table index INDEX or data with KEY and TYPE.
			% INDEX can be a single entry or an array of entries.
			%
			% If the data entry to be removed is a handle, the handle
			% will be deleted from memory unless the setting is altered with a NAME/VALUE pair.
			%
			% This function can be modified by name/value pairs:
			% Parameter (default)         | Description
			% ----------------------------------------------------------------
			% leavehandle (0)             | If the 'data' field of a cache entry is a handle,
			%                             |   leave it in memory.
			%
			% See also: vlt.data.namevaluepair
				disp('DEBUG (remove): Start');
				leavehandle = 0;	
				vlt.data.assign(varargin{:});
			
				if isnumeric(index_or_key),
					index = index_or_key;
				else,
					key = index_or_key;
					index = find ( strcmp(key,{cache_obj.table.key}) & strcmp(type,{cache_obj.table.type}) );
				end

				% delete handles if needed
				if ~leavehandle, 
					for i=1:numel(index),
						if ishandle(cache_obj.table(index(i)).data)
							delete(cache_obj.table(index(i)).data);
						end;
					end
				end;
				cache_obj.table = cache_obj.table(setdiff(1:numel(cache_obj.table),index));
				disp('DEBUG (remove): End. Cache contents:');
				disp(cache_obj.table);
		end % remove

		function cache_obj = clear(cache_obj)
			% CLEAR - clear data from an NDI.CACHE
			%
			% CACHE_OBJ = CLEAR(CACHE_OBJ)
			%
			% Clears all entries from the NDI.CACHE object CACHE_OBJ.
			%
				disp('DEBUG (clear): Start');
				cache_obj = cache_obj.remove(1:numel(cache_obj.table),[]);
				disp('DEBUG (clear): End. Cache contents:');
				disp(cache_obj.table);
		end % clear

		function cache_obj = freebytes(cache_obj, freebytes, newitem)
			% FREEBYTES - remove the lowest priority entries from the cache to free a certain amount of memory
			%
			% CACHE_OBJ = FREEBYTES(CACHE_OBJ, FREEBYTES, [NEWITEM])
			%
			% Remove entries to free at least FREEBYTES memory. Entries will be removed, first by PRIORITY and then by
			% the replacement_rule parameter.
			%
			% If NEWITEM is provided (a structure with fields 'priority','timestamp','bytes'), it is as if that item
			% is already in the cache for the purposes of deciding what to remove.
			%
			% See also: NDI.CACHE/ADD, NDI.CACHE/SET_REPLACEMENT_RULE
			%
				disp('DEBUG (freebytes): Start');
				if nargin > 2,
					table_plus_new = cat(2,cache_obj.table,newitem);
				else,
					table_plus_new = cache_obj.table;
				end;

				stats = [ [table_plus_new.priority]' [table_plus_new.timestamp]' (1:numel(table_plus_new))' [table_plus_new.bytes]' ];
				disp('DEBUG (freebytes): Cache stats before sorting for eviction (Priority, Timestamp, Index, Bytes):');
				disp(stats);
				thesign = 1;
				if strcmpi(cache_obj.replacement_rule,'lifo'), 
					thesign = -1;
				end
				[y,i] = sortrows(stats,[1 thesign*2 thesign*3]);
				disp('DEBUG (freebytes): Sorted indices for eviction:');
				disp(i');
				cumulative_memory_saved = cumsum([table_plus_new(i).bytes]);
				spot = find(cumulative_memory_saved>=freebytes,1,'first');
				disp(['DEBUG (freebytes): Evicting up to index: ' num2str(spot)]);
				if isempty(spot),
					error(['did not expect to be here.']);
				end;
				inds_to_remove = i(1:spot);
				disp(['DEBUG (freebytes): Removing keys: ' strjoin({table_plus_new(inds_to_remove).key}, ', ')]);
				% we can only remove items that are actually in the cache
				inds_to_remove = inds_to_remove(find(inds_to_remove<=numel(cache_obj.table)));
				cache_obj.remove(inds_to_remove,[]);
				disp('DEBUG (freebytes): End. Cache contents:');
				disp(cache_obj.table);
		end

		function tableentry = lookup(cache_obj, key, type)
			% LOOKUP - retrieve the NDI.CACHE data table corresponding to KEY and TYPE
			%
			% TABLEENTRY = LOOKUP(CACHE_OBJ, KEY, TYPE)
			%
			% Performs a case-sensitive lookup of the CACHE entry whose key and type
			% match KEY and TYPE. The table entry is returned. The table has fields:
			%
			% Fieldname         | Description
			% -----------------------------------------------------
			% key               | The key string
			% type              | The type string
			% timestamp         | The Matlab date stamp (serial date number, see NOW) when data was stored
			% priority          | The priority of maintaining the data (higher is better)
			% bytes             | The size of the data in this entry (bytes)
			% data              | The data stored
				disp('DEBUG (lookup): Start');
				index = find ( strcmp(key,{cache_obj.table.key}) & strcmp(type,{cache_obj.table.type}) );
				tableentry = cache_obj.table(index);
				disp('DEBUG (lookup): End. Cache contents:');
				disp(cache_obj.table);
		end % tableentry

		function b = bytes(cache_obj)
			% BYTES - memory size of an NDI.CACHE object in bytes
			%
			% B = BYTES(CACHE_OBJ)
			%
			% Return the current memory that is occupied by the table of CACHE_OBJ.
			%
			%
				disp('DEBUG (bytes): Start');
				b = 0;
				if numel(cache_obj.table) > 0,
					b = sum([cache_obj.table.bytes]);
				end
				disp('DEBUG (bytes): End. Cache contents:');
				disp(cache_obj.table);
		end % bytes

	end % methods
end % vlt.data.cache