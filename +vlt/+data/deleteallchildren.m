function deleteallchildren(h)

% VLT.DATA.DELETEALLCHILDREN - Deletes all children of a graphics handle
%
%   vlt.data.deleteallchildren(H)
%
%   Deletes all children of the graphics handle H. It loops over the
%   children of H and, if they are valid handles, deletes them.
%
%   Example:
%       figure;
%       plot(1:10);
%       hold on;
%       plot(10:-1:1);
%       vlt.data.deleteallchildren(gca); % clears the axes
%
%   See also: DELETE, GCA, GCF, ISHANDLE
%

 
if ishandle(h), g = get(h,'children');
  for i=1:length(g), if ishandle(g(i)), delete(g(i)); end; end;
end;

