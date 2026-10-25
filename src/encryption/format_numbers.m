function s = format_numbers(v, per_row)
% FORMAT_NUMBERS Turn numbers into text: per_row numbers in each line, every number in 4 places, every line starts with 2 spaces.
%   v is a row of whole numbers from 0 to 9999. The lines are separated by a new line character (there is none at the end).
if ~isnumeric(v) || isempty(v) || any(v(:) ~= round(v(:))) || any(v(:) < 0) || any(v(:) > 9999)
    error('format_numbers:range', 'The numbers must be whole numbers from 0 to 9999, at least one.');
end
if ~is_whole_number(per_row) || per_row < 1
    error('format_numbers:width', 'per_row must be one whole number of at least 1.');
end
v = reshape(v, 1, []);
s = '';
for q = 1:per_row:numel(v)
    part = v(q:min(q + per_row - 1, numel(v)));
    row = ['  ' sprintf('%4d', part)];
    if isempty(s)
        s = row;
    else
        s = [s char(10) row];
    end
end
end
