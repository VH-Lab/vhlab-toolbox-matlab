function pretty = prettyjson(json_encoded_object, spacesToIndentEachLevel)
% PRETTYJSON - use Java JSONObject to produce pretty JSON output
%
% PRETTY = vlt.data.prettyjson(JSON_ENCODED_OBJECT, [SPACESTOINDENTEACHLEVEL])
%
% Given a JSON-encoded object (that is, a JSON string), this function
% produces a 'pretty' JSON output that is human-readable (one line per item,
% for example).
% 
% SPACESTOINDENTEACHLEVEL indicates how many spaces should be used to indent each level.
% If it is not provided, 2 is used.
%
% This function calls JSONObject from Java, and requires the org.json.* Java classes.
% This library and its addition to the Java path is provided in
% http://github.com/VH-Lab/vhlab-thirdparty-matlab. If you have this library you
% should be all set.
%
% Example:
%      mystruct = struct('a',5,'b',3,'c',1);
%      j = vlt.data.jsonencodenan(mystruct) % produces single line
%      j_pretty = vlt.data.prettyjson(j) % produces multiple lines
%
%      % or a single line:
%      j_pretty = vlt.data.prettyjson(vlt.data.jsonencodenan(mystruct))

if nargin<2,
	spacesToIndentEachLevel = 2;
end;

try,
	import org.json.JSONObject;
catch,
	error(['This function requires the Java object org.json.JSONObject. Make sure it is installed or that you have vhlab-thirdparty-matlab installed properly.']);
end;

o = JSONObject(json_encoded_object);
pretty = o.toString(spacesToIndentEachLevel); 

