function s = format_names(names, idx, sep)
% FORMAT_NAMES Write the names with the numbers idx as one text, for example Alice, Bob.
%   sep is the text between the names (default ', '). An empty idx gives (none).
if nargin < 3
    sep = ', ';
end
s = '';
for t = 1:numel(idx)
    if t > 1
        s = [s sep];
    end
    s = [s names{idx(t)}];
end
if isempty(idx)
    s = '(none)';
end
end
