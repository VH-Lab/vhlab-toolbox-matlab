function mustBeVectorOrEmpty(a)
% mustBeVectorOrEmpty - Validation function to ensure an input is a vector or is empty
%
% mustBeVectorOrEmpty(A)
%
% Throws an error if A is not a vector and is not empty.
% This is useful for argument validation where an empty value is acceptable.
%

if ~isvector(a) && ~isempty(a)
    eid = 'vlt:validators:mustBeVectorOrEmpty';
    msg = 'Input must be a vector or empty.';
    throwAsCaller(MException(eid,msg));
end

end
