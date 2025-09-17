function t=jsonencodenan(obj)
% VLT.DATA.JSONENCODENAN - Encode a JSON object, preserving NaN and Infinity values
%
%   T = vlt.data.jsonencodenan(OBJ)
%
%   Encodes a Matlab variable OBJ into a JSON string T, while preserving
%   special numeric values like NaN, Inf, and -Inf. This function attempts
%   to use the 'ConvertInfAndNaN' option of Matlab's built-in JSONENCODE
%   function, with fallbacks for older versions.
%
%   Example:
%       my_struct.a = [1 2 NaN Inf -Inf];
%       json_str = vlt.data.jsonencodenan(my_struct);
%
%   See also: JSONENCODE, JSONDECODE
%

try,
    t = jsonencode(obj,'ConvertInfAndNaN',false,'PrettyPrint',true);
catch,
    try,
        t = jsonencode(obj,'ConvertInfAndNaN',false); % for newer version
    catch,
    	t = jsonencode(obj);
    end;
end;
